CREATE OR REPLACE FUNCTION public.fn_valida_codigo_ciudad()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
 IF left(NEW.id_ciud,2) <> NEW.id_dpto THEN
  RAISE EXCEPTION 'El codigo de ciudad % debe comenzar con el codigo de departamento %', NEW.id_ciud, NEW.id_dpto;
 END IF;
 RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION public.fn_valida_telefono_proveedor()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_min SMALLINT; v_max SMALLINT;
BEGIN
 SELECT min_digitos,max_digitos INTO v_min,v_max FROM public.tab_prefijos WHERE cod_prefijo=NEW.cod_prefijo;
 IF NOT FOUND THEN RAISE EXCEPTION 'No existe el prefijo telefonico %',NEW.cod_prefijo; END IF;
 IF length(NEW.num_telefono) NOT BETWEEN v_min AND v_max THEN
  RAISE EXCEPTION 'El numero para % debe tener entre % y % digitos; se recibieron %',NEW.cod_prefijo,v_min,v_max,length(NEW.num_telefono);
 END IF;
 RETURN NEW;
END; $$;

-- Bloqueo de encabezado para serializar cambios en lineas y pagos de la misma factura.
CREATE OR REPLACE FUNCTION public.fn_bloquea_factura_detalle()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_factura NUMERIC(6,0);
BEGIN
 IF TG_OP='DELETE' THEN v_factura:=OLD.id_factura; ELSE v_factura:=NEW.id_factura; END IF;
 IF TG_OP='UPDATE' AND NEW.id_factura<>OLD.id_factura THEN
  RAISE EXCEPTION 'No se permite trasladar una linea a otra factura; elimine e inserte la linea en la factura destino';
 END IF;
 PERFORM 1 FROM public.tab_enc_compra WHERE id_factura=v_factura FOR UPDATE;
 IF NOT FOUND THEN RAISE EXCEPTION 'No existe la factura %',v_factura; END IF;
 IF TG_OP='DELETE' THEN RETURN OLD; END IF;
 RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION public.fn_valida_detalle_compra()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_prov NUMERIC(10,0); v_prov_activo BOOLEAN; v_prod_activo BOOLEAN; v_disponible BOOLEAN;
BEGIN
 SELECT id_prov INTO v_prov FROM public.tab_enc_compra WHERE id_factura=NEW.id_factura;
 IF NOT FOUND THEN RAISE EXCEPTION 'No existe la factura %',NEW.id_factura; END IF;
 SELECT pr.ind_estado,p.ind_estado,pp.ind_disp INTO v_prov_activo,v_prod_activo,v_disponible
 FROM public.tab_prod_prov pp JOIN public.tab_prov pr ON pr.id_prov=pp.id_prov JOIN public.tab_prod p ON p.id_prod=pp.id_prod
 WHERE pp.id_prov=v_prov AND pp.id_prod=NEW.id_prod FOR SHARE OF pp,pr,p;
 IF NOT FOUND THEN RAISE EXCEPTION 'El proveedor % no tiene asociado el producto %',v_prov,NEW.id_prod; END IF;
 IF NOT v_prov_activo THEN RAISE EXCEPTION 'El proveedor % esta inactivo',v_prov; END IF;
 IF NOT v_prod_activo THEN RAISE EXCEPTION 'El producto % esta inactivo',NEW.id_prod; END IF;
 IF NOT v_disponible THEN RAISE EXCEPTION 'El producto % no esta disponible para el proveedor %',NEW.id_prod,v_prov; END IF;
 RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION public.fn_valida_pago_factura()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_total_factura NUMERIC(12,0); v_total_pagado NUMERIC(12,0);
BEGIN
 PERFORM 1 FROM public.tab_enc_compra WHERE id_factura=NEW.id_factura FOR UPDATE;
 IF NOT FOUND THEN RAISE EXCEPTION 'No existe la factura %',NEW.id_factura; END IF;
 SELECT COALESCE(SUM(val_neto),0) INTO v_total_factura FROM public.tab_det_compra WHERE id_factura=NEW.id_factura;
 IF v_total_factura<=0 THEN RAISE EXCEPTION 'No se permiten pagos para una factura sin detalle o con total cero'; END IF;
 IF TG_OP='INSERT' THEN
  SELECT COALESCE(SUM(val_pago),0) INTO v_total_pagado FROM public.tab_pagos WHERE id_factura=NEW.id_factura;
 ELSE
  SELECT COALESCE(SUM(val_pago),0) INTO v_total_pagado FROM public.tab_pagos
   WHERE id_factura=NEW.id_factura AND (id_factura,id_pago)<>(OLD.id_factura,OLD.id_pago);
 END IF;
 IF v_total_pagado+NEW.val_pago>v_total_factura THEN
  RAISE EXCEPTION 'Pago rechazado: total factura %, pagos existentes %, nuevo pago %',v_total_factura,v_total_pagado,NEW.val_pago;
 END IF;
 RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION public.fn_saldo_factura(p_id_factura NUMERIC(6,0))
RETURNS NUMERIC(12,0) LANGUAGE sql STABLE AS $$
 SELECT (COALESCE((SELECT SUM(val_neto) FROM public.tab_det_compra WHERE id_factura=p_id_factura),0)
       - COALESCE((SELECT SUM(val_pago) FROM public.tab_pagos WHERE id_factura=p_id_factura),0))::NUMERIC(12,0);
$$;



CREATE OR REPLACE TRIGGER trg_valida_codigo_ciudad
BEFORE INSERT OR UPDATE OF id_ciud,id_dpto ON public.tab_ciud
FOR EACH ROW EXECUTE FUNCTION public.fn_valida_codigo_ciudad();

CREATE OR REPLACE TRIGGER trg_valida_telefono_proveedor
BEFORE INSERT OR UPDATE OF cod_prefijo,num_telefono ON public.tab_tel_prov
FOR EACH ROW EXECUTE FUNCTION public.fn_valida_telefono_proveedor();

CREATE OR REPLACE TRIGGER trg_bloquea_factura_detalle
BEFORE INSERT OR UPDATE OR DELETE ON public.tab_det_compra
FOR EACH ROW EXECUTE FUNCTION public.fn_bloquea_factura_detalle();

CREATE OR REPLACE TRIGGER trg_valida_detalle_compra
BEFORE INSERT OR UPDATE OF id_factura,id_prod ON public.tab_det_compra
FOR EACH ROW EXECUTE FUNCTION public.fn_valida_detalle_compra();

CREATE OR REPLACE TRIGGER trg_valida_pago_factura
BEFORE INSERT OR UPDATE ON public.tab_pagos
FOR EACH ROW EXECUTE FUNCTION public.fn_valida_pago_factura();

CREATE OR REPLACE FUNCTION public.fn_valida_telefono_proveedor()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_min SMALLINT;
    v_max SMALLINT;
BEGIN
    SELECT num_digitos_min, num_digitos_max
    INTO v_min, v_max
    FROM public.tab_prefijos
    WHERE cod_prefijo = NEW.cod_prefijo;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el prefijo telefonico %', NEW.cod_prefijo;
    END IF;

    IF length(NEW.num_telefono) NOT BETWEEN v_min AND v_max THEN
        RAISE EXCEPTION
            'El numero para % debe tener entre % y % digitos; se recibieron %',
            NEW.cod_prefijo,
            v_min,
            v_max,
            length(NEW.num_telefono);
    END IF;

    RETURN NEW;
END;
$$;