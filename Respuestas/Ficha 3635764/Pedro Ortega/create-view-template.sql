CREATE OR REPLACE VIEW public.vw_estado_factura AS
SELECT e.id_factura,e.fec_factura,e.id_prov,p.nom_comp AS proveedor,
 COALESCE(d.total_bruto,0) AS total_bruto,COALESCE(d.total_descuento,0) AS total_descuento,
 COALESCE(d.total_iva,0) AS total_iva,COALESCE(d.total_neto,0) AS total_factura,
 COALESCE(pg.total_pagado,0) AS total_pagado,
 COALESCE(d.total_neto,0)-COALESCE(pg.total_pagado,0) AS saldo,
 CASE WHEN COALESCE(d.total_neto,0)=0 THEN 'SIN DETALLE'
      WHEN COALESCE(pg.total_pagado,0)=0 THEN 'PENDIENTE'
      WHEN COALESCE(pg.total_pagado,0)<COALESCE(d.total_neto,0) THEN 'PAGO PARCIAL'
      WHEN COALESCE(pg.total_pagado,0)=COALESCE(d.total_neto,0) THEN 'PAGADA' ELSE 'SOBREPAGO' END AS estado_pago
FROM public.tab_enc_compra e JOIN public.tab_prov p ON p.id_prov=e.id_prov
LEFT JOIN (SELECT id_factura,SUM(val_bruto) total_bruto,SUM(val_descu) total_descuento,SUM(val_iva) total_iva,SUM(val_neto) total_neto
           FROM public.tab_det_compra GROUP BY id_factura) d ON d.id_factura=e.id_factura
LEFT JOIN (SELECT id_factura,SUM(val_pago) total_pagado FROM public.tab_pagos GROUP BY id_factura) pg ON pg.id_factura=e.id_factura;

CREATE OR REPLACE VIEW public.vw_productos_proveedores AS
SELECT
    pr.id_prod,
    pr.nom_prod,
    pr.ind_estado AS producto_activo,
    pv.id_prov,
    pv.nom_comp AS proveedor,
    pp.val_prod,
    pp.ind_disp AS disponible
FROM public.tab_prod_prov pp
JOIN public.tab_prod pr
    ON pr.id_prod = pp.id_prod
JOIN public.tab_prov pv
    ON pv.id_prov = pp.id_prov;

CREATE OR REPLACE VIEW public.vw_resumen_ordenes_area AS
SELECT a.id_area,a.nom_area,COUNT(DISTINCT o.id_orden) AS cantidad_ordenes,COALESCE(SUM(d.val_cant),0) AS unidades_solicitadas
FROM public.tab_areas a LEFT JOIN public.tab_orden_compra o ON o.id_area=a.id_area
LEFT JOIN public.tab_det_orden d ON d.id_orden=o.id_orden GROUP BY a.id_area,a.nom_area;