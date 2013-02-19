-- ========================================================================================
-- PREINSTALL FROM 13.01
-- ========================================================================================
-- 	Consideraciones importantes:
--			1) NO hacer cambios en el archivo, realizar siempre APPENDs al final del mismo 
-- 			2) Recordar realizar las adiciones con un comentario con formato YYYYMMDD-HHMM
-- ========================================================================================

-- 20130129-1400 - Incorporaciones necesarias para desarrollo Libertya Web
CREATE TABLE libertya.ad_entitytype
(
  entitytype character varying(40) NOT NULL DEFAULT 'D'::character varying,
  ad_client_id numeric(10,0) NOT NULL,
  ad_org_id numeric(10,0) NOT NULL,
  ad_entitytype_id numeric(10,0) NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  created timestamp without time zone NOT NULL DEFAULT now(),
  createdby numeric(10,0) NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT now(),
  updatedby numeric(10,0) NOT NULL,
  name character varying(60) NOT NULL,
  description character varying(255),
  help character varying(2000),
  version character varying(20),
  modelpackage character varying(255),
  classpath character varying(255),
  processing character(1),
  CONSTRAINT ad_entitytype_pkey PRIMARY KEY (entitytype),
  CONSTRAINT ad_entitytype_isactive_check CHECK (isactive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]))
);

CREATE TABLE libertya.pa_dashboardcontent
(
  pa_dashboardcontent_id numeric(10,0) NOT NULL,
  ad_client_id numeric(10,0) NOT NULL,
  ad_org_id numeric(10,0) NOT NULL,
  created timestamp without time zone NOT NULL,
  createdby numeric(10,0) NOT NULL,
  updated timestamp without time zone NOT NULL,
  updatedby numeric(10,0) NOT NULL,
  isactive character(1) NOT NULL,
  name character varying(120) NOT NULL,
  ad_window_id int,
  description character varying(255),
  html text,
  line numeric,
  pa_goal_id numeric(10,0) null,
  columnno numeric(10,0) DEFAULT 1,
  zulfilepath character varying(255),
  iscollapsible character(1) NOT NULL DEFAULT 'Y'::bpchar,
  goaldisplay character(1) DEFAULT 'T'::bpchar,
  isopenbydefault character(1) DEFAULT 'Y'::bpchar,
  CONSTRAINT pa_dashboardcontent_pkey PRIMARY KEY (pa_dashboardcontent_id),
  CONSTRAINT adwindow_padashboardcontent FOREIGN KEY (ad_window_id)
      REFERENCES libertya.ad_window (ad_window_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
--  CONSTRAINT pagoal_padashboardcontent FOREIGN KEY (pa_goal_id)
--      REFERENCES libertya.pa_goal (pa_goal_id) MATCH SIMPLE
--      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT pa_dashboardcontent_isactive_check CHECK (isactive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar])),
  CONSTRAINT pa_dashboardcontent_iscollapsible_check CHECK (iscollapsible = ANY (ARRAY['Y'::bpchar, 'N'::bpchar])),
  CONSTRAINT pa_dashboardcontent_isopenbydefault_check CHECK (isopenbydefault = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]))
);

CREATE TABLE libertya.pa_dashboardcontent_trl
(
  ad_client_id numeric(10,0) NOT NULL,
  ad_language character varying(6) NOT NULL,
  ad_org_id numeric(10,0) NOT NULL,
  created timestamp without time zone NOT NULL DEFAULT now(),
  createdby numeric(10,0) NOT NULL,
  description character varying(255),
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  istranslated character(1) NOT NULL,
  name character varying(60) NOT NULL,
  pa_dashboardcontent_id numeric(10,0) NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT now(),
  updatedby numeric(10,0) NOT NULL,
  CONSTRAINT pa_dashboardcontent_trl_pkey PRIMARY KEY (ad_language, pa_dashboardcontent_id),
  CONSTRAINT adlangu_padashboardcontenttrl FOREIGN KEY (ad_language)
      REFERENCES libertya.ad_language (ad_language) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT padashboardcontent_padashboard FOREIGN KEY (pa_dashboardcontent_id)
      REFERENCES libertya.pa_dashboardcontent (pa_dashboardcontent_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT pa_dashboardcontent_trl_isactive_check CHECK (isactive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar])),
  CONSTRAINT pa_dashboardcontent_trl_istranslated_check CHECK (istranslated = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]))
);

CREATE TABLE libertya.ad_sysconfig
(
  ad_sysconfig_id numeric(10,0) NOT NULL,
  ad_client_id numeric(10,0) NOT NULL,
  ad_org_id numeric(10,0) NOT NULL,
  created timestamp without time zone NOT NULL,
  updated timestamp without time zone NOT NULL,
  createdby numeric(10,0) NOT NULL,
  updatedby numeric(10,0) NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  name character varying(50) NOT NULL,
  value character varying(255) NOT NULL,
  description character varying(255),
  entitytype character varying(40) NOT NULL DEFAULT 'U'::character varying,
  configurationlevel character(1) DEFAULT 'S'::bpchar,
  CONSTRAINT ad_sysconfig_pkey PRIMARY KEY (ad_sysconfig_id),
  CONSTRAINT entityt_adsysconfig FOREIGN KEY (entitytype)
      REFERENCES libertya.ad_entitytype (entitytype) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT ad_sysconfig_isactive_check CHECK (isactive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]))
);


CREATE TABLE libertya.ad_userquery
(
  ad_userquery_id numeric(10,0) NOT NULL,
  ad_client_id numeric(10,0) NOT NULL,
  ad_org_id numeric(10,0) NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  created timestamp without time zone NOT NULL DEFAULT now(),
  createdby numeric(10,0) NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT now(),
  updatedby numeric(10,0) NOT NULL,
  name character varying(60) NOT NULL,
  description character varying(255),
  ad_user_id int,
  ad_table_id int NOT NULL,
  code character varying(2000),
  ad_tab_id int,
  CONSTRAINT ad_userquery_pkey PRIMARY KEY (ad_userquery_id),
  CONSTRAINT adtab_aduserquery FOREIGN KEY (ad_tab_id)
      REFERENCES libertya.ad_tab (ad_tab_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT adtable_aduserquery FOREIGN KEY (ad_table_id)
      REFERENCES libertya.ad_table (ad_table_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT aduser_aduserquery FOREIGN KEY (ad_user_id)
      REFERENCES libertya.ad_user (ad_user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT ad_userquery_isactive_check CHECK (isactive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]))
);


CREATE TABLE libertya.ad_searchdefinition
(
  ad_client_id numeric(10,0) NOT NULL,
  ad_column_id int,
  ad_org_id numeric(10,0) NOT NULL,
  ad_searchdefinition_id int NOT NULL,
  ad_table_id int NOT NULL,
  ad_window_id int NOT NULL,
  created timestamp without time zone,
  createdby numeric(10,0),
  datatype character varying(1) NOT NULL,
  description character varying(255),
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  name character varying(60),
  query character varying(2000),
  searchtype character varying(1) NOT NULL,
  transactioncode character varying(8),
  updated timestamp without time zone NOT NULL,
  updatedby numeric(10,0) NOT NULL,
  po_window_id int,
  isdefault character(1) NOT NULL DEFAULT 'N'::bpchar,
  CONSTRAINT ad_searchdefinition_pkey PRIMARY KEY (ad_searchdefinition_id),
  CONSTRAINT adcolumn_adsearchdefinition FOREIGN KEY (ad_column_id)
      REFERENCES libertya.ad_column (ad_column_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT adtable_adsearchdefinition FOREIGN KEY (ad_table_id)
      REFERENCES libertya.ad_table (ad_table_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT adwindow_adsearchdefinition FOREIGN KEY (ad_window_id)
      REFERENCES libertya.ad_window (ad_window_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT powindow_adsearchdefinition FOREIGN KEY (po_window_id)
      REFERENCES libertya.ad_window (ad_window_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT ad_searchdefinition_isactive_check CHECK (isactive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar])),
  CONSTRAINT ad_searchdefinition_isdefault_check CHECK (isdefault = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]))
);

ALTER TABLE ad_printformat add column jasperprocess_id int null;
ALTER TABLE ad_process add column ad_form_id int null;
ALTER TABLE c_acctschema add column AD_OrgOnly_ID int null;
ALTER TABLE c_invoice add column m_rma_id int null;
ALTER TABLE AD_ROLE ADD COLUMN confirmqueryrecords numeric(10,0) NOT NULL DEFAULT 0;
ALTER TABLE AD_ROLE ADD COLUMN maxqueryrecords numeric(10,0) NOT NULL DEFAULT 0;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_account character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_asset character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_bpartner character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_cashjournal character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_inout character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_invoice character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_order character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_payment character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_product character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_resource character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_schedule character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_mrp character(1) NOT NULL DEFAULT 'Y'::bpchar;
ALTER TABLE AD_ROLE ADD COLUMN allow_info_crp character(1) NOT NULL DEFAULT 'Y'::bpchar;

INSERT INTO ad_entitytype (entitytype, ad_client_id, ad_org_id, ad_entitytype_id, isactive, created, createdby, updated, updatedby, name, description, help, version, modelpackage, classpath, processing)
VALUES ('D',0,0,10,'Y',now(),100,now(),0,'Dictionary','Application Dictionary Ownership ** System Maintained **','The entity is owned by the Application Dictionary.','','','','N');

INSERT INTO PA_Dashboardcontent (pa_dashboardcontent_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, ad_window_id, description, html, line, pa_goal_id, columnno, zulfilepath, iscollapsible, goaldisplay, isopenbydefault)
VALUES (50000,0,0,now(),0,now(),0,'Y','Activities',null,'Workflow activities, notices and requests','',0,null,0,'/zul/activities.zul','Y','T','Y');
INSERT INTO PA_Dashboardcontent (pa_dashboardcontent_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, ad_window_id, description, html, line, pa_goal_id, columnno, zulfilepath, iscollapsible, goaldisplay, isopenbydefault)
VALUES (50001,0,0,now(),0,now(),0,'Y','Favourites',null,'User favourities','',1,null,0,'/zul/favourites.zul','Y','T','Y');
INSERT INTO PA_Dashboardcontent (pa_dashboardcontent_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, ad_window_id, description, html, line, pa_goal_id, columnno, zulfilepath, iscollapsible, goaldisplay, isopenbydefault)
VALUES (50002,0,0,now(),0,now(),0,'Y','Views',null,'Info views','',2,null,0,'/zul/views.zul','Y','T','Y');
INSERT INTO PA_Dashboardcontent (pa_dashboardcontent_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, ad_window_id, description, html, line, pa_goal_id, columnno, zulfilepath, iscollapsible, goaldisplay, isopenbydefault)
VALUES (50003,0,0,now(),0,now(),0,'Y','Performance',null,'Performance meters','',0,null,2,'/zul/performance.zul','Y','T','Y');
INSERT INTO PA_Dashboardcontent (pa_dashboardcontent_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, ad_window_id, description, html, line, pa_goal_id, columnno, zulfilepath, iscollapsible, goaldisplay, isopenbydefault)
VALUES (50004,11,0,now(),0,now(),0,'Y','Calendar',null,'Google Calendar','',0,null,1,'/zul/calendar.zul','Y','T','Y');

INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_MX',0,now(),0,'Actividades de flujo de trabajo, avisos y solicitudes','Y','Y','Actividades',50000,'2011-08-25 09:13:42',0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_MX',0,now(),0,'Favoritos de usuario','Y','Y','Favoritos',50001,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_MX',0,now(),0,'Vistas de Información','Y','Y','Vistas',50002,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_MX',0,now(),0,'Indicadores de Desempeño','Y','Y','Desempeño',50003,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (11,'es_MX',0,now(),0,'Calendario de Google','Y','Y','Calendario',50004,now(),0);

INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_AR',0,now(),0,'Actividades de flujo de trabajo, avisos y solicitudes','Y','Y','Actividades',50000,'2011-08-25 09:13:42',0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_AR',0,now(),0,'Favoritos de usuario','Y','Y','Favoritos',50001,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_AR',0,now(),0,'Vistas de Información','Y','Y','Vistas',50002,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_AR',0,now(),0,'Indicadores de Desempeño','Y','Y','Desempeño',50003,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (11,'es_AR',0,now(),0,'Calendario de Google','Y','Y','Calendario',50004,now(),0);

INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_PY',0,now(),0,'Actividades de flujo de trabajo, avisos y solicitudes','Y','Y','Actividades',50000,'2011-08-25 09:13:42',0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_PY',0,now(),0,'Favoritos de usuario','Y','Y','Favoritos',50001,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_PY',0,now(),0,'Vistas de Información','Y','Y','Vistas',50002,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_PY',0,now(),0,'Indicadores de Desempeño','Y','Y','Desempeño',50003,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (11,'es_PY',0,now(),0,'Calendario de Google','Y','Y','Calendario',50004,now(),0);

INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_ES',0,now(),0,'Actividades de flujo de trabajo, avisos y solicitudes','Y','Y','Actividades',50000,'2011-08-25 09:13:42',0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_ES',0,now(),0,'Favoritos de usuario','Y','Y','Favoritos',50001,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_ES',0,now(),0,'Vistas de Información','Y','Y','Vistas',50002,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (0,'es_ES',0,now(),0,'Indicadores de Desempeño','Y','Y','Desempeño',50003,now(),0);
INSERT INTO pa_dashboardcontent_trl (ad_client_id, ad_language, ad_org_id, created, createdby, description, isactive, istranslated, name, pa_dashboardcontent_id, updated, updatedby)
VALUES (11,'es_ES',0,now(),0,'Calendario de Google','Y','Y','Calendario',50004,now(),0);

INSERT INTO AD_SYSCONFIG (ad_sysconfig_id, ad_client_id, ad_org_id, created, updated, createdby, updatedby, isactive, name, value, description, entitytype, configurationlevel)
VALUES (50018,0,0,now(),now(),100,100,'Y','ZK_PAGING_SIZE','100','Default paging size for grid view in zk webui','D','S');
INSERT INTO AD_SYSCONFIG (ad_sysconfig_id, ad_client_id, ad_org_id, created, updated, createdby, updatedby, isactive, name, value, description, entitytype, configurationlevel)
VALUES (50019,0,0,now(),now(),100,100,'Y','ZK_GRID_EDIT_MODELESS','N','Grid view will enter in edit mode','D','S');
INSERT INTO AD_SYSCONFIG (ad_sysconfig_id, ad_client_id, ad_org_id, created, updated, createdby, updatedby, isactive, name, value, description, entitytype, configurationlevel)
VALUES (50020,0,0,now(),now(),100,100,'Y','ZK_DASHBOARD_REFRESH_INTERVAL','60000','Milliseconds of wait to run the dashboard refresh on zk webui client','D','S');
INSERT INTO AD_SYSCONFIG (ad_sysconfig_id, ad_client_id, ad_org_id, created, updated, createdby, updatedby, isactive, name, value, description, entitytype, configurationlevel)
VALUES (50021,0,0,now(),now(),100,100,'Y','ZK_DESKTOP_CLASS','org.adempiere.webui.desktop.DefaultDesktop','package+classname of zk desktop class','D','S');
INSERT INTO AD_SYSCONFIG (ad_sysconfig_id, ad_client_id, ad_org_id, created, updated, createdby, updatedby, isactive, name, value, description, entitytype, configurationlevel)
VALUES (50025,0,0,now(),now(),100,100,'Y','WEBUI_LOGOURL','/images/AD10030.png','url for the logo in zkwebui','D','S');
INSERT INTO AD_SYSCONFIG (ad_sysconfig_id, ad_client_id, ad_org_id, created, updated, createdby, updatedby, isactive, name, value, description, entitytype, configurationlevel)
VALUES (50037,0,0,now(),now(),100,100,'Y','ZK_LOGIN_ALLOW_REMEMBER_ME','U','Allow remember me on zkwebui - allowed values [U]ser / [P]assword / [N]one','D','S');
INSERT INTO AD_SYSCONFIG (ad_sysconfig_id, ad_client_id, ad_org_id, created, updated, createdby, updatedby, isactive, name, value, description, entitytype, configurationlevel)
VALUES (50050,0,0,now(),now(),100,100,'Y','ZK_ROOT_FOLDER_BROWSER','/opt/adempiere/current/data','Root Folder to be used when opening server files.','D','S');

-- 20130204-1135 Nuevas modificaciones a funcionalidad de replicacion
CREATE OR REPLACE FUNCTION replication_event()
  RETURNS trigger AS
$BODY$
DECLARE 
	found integer; 
	replicationPos integer;
	v_newRepArray varchar; 
	aKeyColumn varchar;
	repSeq bigint;
	shouldReplicate varchar;
	recordColumns RECORD;
	columnValue varchar;
	isValid integer;
	v_valueDetail varchar;
	v_nameDetail varchar;
	v_columnname varchar;
        v_tableid int; 
        v_tablename varchar;
        v_referenceStr varchar;
	v_referencedTableStr varchar;
	v_referencedTableID int;
	v_existsValueField int;
	v_existsNameField int;
	shouldcheckreferences boolean;
BEGIN 
	-- se deberan verificar referencias a registros fuera del esquema de replicacion? (inicialmente no)
	shouldcheckreferences := false;

	-- estamos en una accion de eliminacion?
	IF (TG_OP = 'DELETE') THEN

		-- Checkear switch maestro de replicacion
		SELECT INTO shouldReplicate VALUE FROM AD_PREFERENCE WHERE ATTRIBUTE = 'ReplicationEventsActive';
		IF (shouldReplicate <> 'Y') THEN
			RETURN OLD;
		END IF;

		-- Se repArray es nulo o vacio, no hay mas que hacer dado que es un registro fuera de replicacion
		IF (OLD.repArray IS NULL OR OLD.repArray = '') THEN
			RETURN OLD;
		END IF;

		-- El registro fue replicado? Si no lo fue puede ser eliminado, pero en caso contrario hay que registrar su eliminacion
		IF replication_is_record_replicated(OLD.repArray) = 1 THEN

			-- Recuperar el repArray de la tabla en cuestion
			SELECT INTO v_newRepArray replicationArray 
			FROM ad_tablereplication 
			WHERE ad_table_ID = TG_ARGV[0]::int;

			-- Cambiar 3 (replicacion bidireccional) por 1 (enviar); y 2 (recibir) por 0 (sin accion)
			v_newRepArray := replace(v_newRepArray, '3', '1');
			v_newRepArray := replace(v_newRepArray, '2', '0');

			-- Insertar en la tabla de eliminaciones
			IF v_newRepArray IS NOT NULL AND v_newRepArray <> '' THEN
				INSERT INTO ad_changelog_replication (AD_Changelog_Replication_ID, AD_Client_ID, AD_Org_ID, isActive, Created, CreatedBy, Updated, UpdatedBy, AD_Table_ID, retrieveUID, operationtype, binaryvalue, reparray, columnvalues, includeInReplication)
				SELECT nextval('seq_ad_changelog_replication'),OLD.AD_Client_ID,OLD.AD_Org_ID,'Y',now(),OLD.CreatedBy,now(),OLD.UpdatedBy,TG_ARGV[0]::int,OLD.retrieveUID,'I',null,v_newRepArray,null,'Y';
			END IF;
		END IF;	
		
		RETURN OLD;
	END IF;
	-- estamos en una accion de insercion o actualizacion?
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN

		-- Checkear switch maestro de replicacion		
		SELECT INTO shouldReplicate VALUE FROM AD_PREFERENCE WHERE ATTRIBUTE = 'ReplicationEventsActive';
		IF (shouldReplicate <> 'Y') THEN
			RETURN NEW;
		END IF;

		-- El uso de SKIP se supone para omitir acciones posteriores en eliminacion (dado que setea repArray en NULL)
		IF (NEW.repArray = 'SKIP') THEN
			NEW.repArray := NULL;
			return NEW;
		END IF;

		-- Verificar si hay que generar el retrieveUID. Ejemplo: h1_291
		IF NEW.retrieveUID IS NULL OR NEW.retrieveUID = '' THEN 
			-- Obtener posicion de host
			SELECT INTO replicationPos replicationArrayPos FROM AD_ReplicationHost WHERE thisHost = 'Y'; 
			IF replicationPos IS NULL THEN RAISE EXCEPTION 'Configuracion de Hosts incompleta: Ninguna sucursal tiene marca de Este Host'; END IF; 
			-- Obtener siguiente valor para la tabla dada
			SELECT INTO repseq nextVal('repseq_' || TG_ARGV[1]);
			IF repseq IS NULL THEN RAISE EXCEPTION 'No hay definida una secuencia de replicacion para la tabla %', TG_ARGV[1]; END IF;
			NEW.retrieveUID := 'h'::varchar || replicationPos::varchar || '_' || repseq || '_' || lower(TG_ARGV[1]);
		END IF;		

		-- Si estamos insertando...
		IF (TG_OP = 'INSERT') THEN

			-- Si se indico el repArray con SET, entonces se esta configurando el registro manualmente.  No hacer nada mas.
			IF (substr(NEW.repArray, 1, 3) = 'SET') THEN
				NEW.repArray := substr(NEW.repArray, 4, length(NEW.repArray)-3);
			ELSE
				-- Recuperar el repArray
				SELECT INTO v_newRepArray replicationArray 
				FROM ad_tablereplication 
				WHERE ad_table_ID = TG_ARGV[0]::int;

				-- Si es nulo o vacio no hacer nada mas
				IF v_newRepArray IS NULL OR v_newRepArray = '' THEN
					RETURN NEW;
				END IF;

				-- Cambiar 3 (replicacion bidireccional) por 1 (enviar); y 2 (recibir) por 0 (sin accion)
				NEW.repArray := replace(v_newRepArray, '3', '1');
				NEW.repArray := replace(NEW.repArray, '2', '0');
				-- Si el registro deberá replicar hacia otros hosts (hay al menos un 1)
				-- entonces debe incluirse en replicacion y hay que check referencias
				IF (position('1' in NEW.repArray) > 0) THEN
					NEW.includeInReplication = 'Y';
					shouldcheckreferences := true;
				ELSE
					NEW.repArray := NULL;
				END IF;
			END IF;
			
		-- Si estamos actualizando...
		ELSEIF (TG_OP = 'UPDATE') THEN 

			-- Si se indico el repArray con SET, entonces se esta configurando el registro manualmente.  No hacer nada mas.		
			IF (substr(NEW.repArray, 1, 3) = 'SET') THEN
				NEW.repArray := substr(NEW.repArray, 4, length(NEW.repArray)-3);
			ELSE
				-- El repArray no esta seteado todavia? (Caso: modificacion de un registro preexistente)
				IF (OLD.repArray IS NULL OR OLD.repArray = '0') THEN

					-- Recuperar el repArray
					SELECT INTO v_newRepArray replicationArray 
					FROM ad_tablereplication 
					WHERE ad_table_ID = TG_ARGV[0]::int;

					-- Cambiar 2 (recibir) por 0 (sin accion)
					NEW.repArray := replace(v_newRepArray, '2', '0');
					-- Cambiar 1 (enviar) y 3 (bidireccional) por 2 (replicado)
					NEW.repArray := replace(NEW.repArray, '1', '2');
					NEW.repArray := replace(NEW.repArray, '3', '2');
				END IF;

				-- Cambiar los 2 (replicado) por 3 (modificado).
				-- Adicionalmente para JMS: 4 (espera ack) por 5 (cambios luego de ack)
				NEW.repArray := replace(NEW.repArray, '2', '3');
				NEW.repArray := replace(NEW.repArray, '4', '5');
				-- Si el registro deberá replicar hacia otros hosts (hay al menos un 3)
				-- entonces debe incluirse en replicacion y hay que check referencias
				IF (position('3' in NEW.repArray) > 0) THEN
					NEW.includeInReplication = 'Y';
					shouldcheckreferences := true;
				END IF;
			END IF;
		END IF;
	END IF;

	IF (shouldcheckreferences = true) THEN

		-- Validar referencias iterando todas las columnas de la tabla
		FOR recordColumns IN
			SELECT isc.column_name, isc.data_type, c.ad_column_id, t.tablename, t.ad_table_id
			FROM information_schema.columns isc
			INNER JOIN ad_table t ON lower(isc.table_name) = lower(t.tablename)
			INNER JOIN ad_column c ON lower(isc.column_name) = lower(c.columnname) AND t.ad_table_id = c.ad_table_id
			WHERE table_name = quote_ident(TG_TABLE_NAME)
			AND isc.data_type = 'integer'
			AND isc.column_name not in ('retrieveuid', 'reparray', 'datelastsentjms', 'includeinreplication')
		LOOP
			-- Obtener el value de la columna y verificar si es referencia valida.  En caso de no serlo, presentar error correspondiente
			EXECUTE 'SELECT (' || quote_literal(NEW) || '::' || TG_RELID::regclass || ').' || quote_ident(recordColumns.column_name) INTO columnValue;
			SELECT INTO isValid replication_is_valid_reference(recordColumns.ad_column_id, columnvalue);
			IF isValid = 0 THEN

				-- valores por defecto
				v_valueDetail := '';
				v_nameDetail := '';
				v_referenceStr := '';
				
				-- recuperar el nombre de la columna y tabla para brindar un mensaje mas intuitivo al usuario
				v_columnname := recordColumns.column_name;
				v_tablename := recordColumns.tablename;

				BEGIN 
					-- recuperar el nombre o value del registro referenciado a fin de mejorar la legibilidad del mensaje de error
					SELECT INTO v_referencedTableStr replication_get_referenced_table(recordColumns.ad_column_id);
					SELECT INTO v_referencedTableID AD_Table_ID FROM AD_Table WHERE tablename ilike v_referencedTableStr;

					-- ver si existe las columnas value y name
					SELECT INTO v_existsValueField Count(1) FROM AD_Column WHERE columnname ilike 'Value' AND AD_Table_ID = v_referencedTableID;
					SELECT INTO v_existsNameField Count(1) FROM AD_Column WHERE columnname ilike 'Name' AND AD_Table_ID = v_referencedTableID;

					-- cargar value y name
					IF v_existsValueField = 1 THEN
						EXECUTE 'SELECT value FROM ' || v_referencedTableStr || ' WHERE ' || v_referencedTableStr || '_ID = ' || columnvalue || '::int' INTO v_valueDetail;
						v_referenceStr := v_valueDetail;
					END IF;
					IF v_existsNameField = 1 THEN
						EXECUTE 'SELECT name FROM ' || v_referencedTableStr || ' WHERE ' || v_referencedTableStr || '_ID = ' || columnvalue || '::int' INTO v_nameDetail;
						v_referenceStr := v_referenceStr || ' ' || v_nameDetail;
					END IF;
				EXCEPTION
					WHEN OTHERS THEN
						-- do nothing
				END;
				
				-- concatenar acordemente para mensaje de retorno
				RAISE EXCEPTION 'Validacion de replicación - La columna: % (%) de la tabla: % (%) referencia al registro: % (%), fuera del sistema de replicacion.', v_columnname, recordColumns.ad_column_id, v_tablename, recordColumns.ad_table_id, v_referenceStr, columnvalue;
			END IF;
		END LOOP;

	END IF;
	RETURN NEW;
END; 
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION replication_event() OWNER TO libertya;

ALTER TABLE ad_replicationhost ADD column username varchar null;
ALTER TABLE ad_replicationhost ADD column password varchar null;

-- 20130205-1105 - Incorporaciones faltantes necesarias para desarrollo Libertya Web 
update ad_system set dummy = (SELECT addcolumnifnotexists('AD_Role','connectionprofile', 'character(1)'));
update ad_system set dummy = (SELECT addcolumnifnotexists('AD_Role','userdiscount', 'numeric(22,0)'));

-- 20130214-1430 Nueva vista para el reporte de existencias por producto adicionando información del artículo como proveedor, precio de costo y venta
CREATE OR REPLACE VIEW rv_storage_product_plus AS 
SELECT ad_client_id, ad_org_id, m_product_id, value, name, m_product_category_id, m_warehouse_id, qtyonhand, qtyreserved, qtyavailable, qtyordered, (SELECT c_bpartner_id FROM m_product_po po WHERE po.m_product_id = p.m_product_id ORDER BY iscurrentvendor LIMIT 1) as c_bpartner_id, coalesce((SELECT pp.pricelist FROM m_productprice as pp INNER JOIN m_pricelist_version as plv ON pp.m_pricelist_version_id = plv.m_pricelist_version_id INNER JOIN m_pricelist as pl ON pl.m_pricelist_id = plv.m_pricelist_id WHERE pl.issopricelist = 'Y' AND pl.isactive = 'Y' AND plv.isactive = 'Y' AND pp.isactive = 'Y' AND (pl.ad_org_id = p.ad_org_id OR pl.ad_org_id = 0) AND pp.m_product_id = p.m_product_id ORDER BY pl.ad_org_id DESC, plv.validfrom DESC LIMIT 1),0) as sales_pricelist, coalesce((SELECT pp.pricelist FROM m_productprice as pp INNER JOIN m_pricelist_version as plv ON pp.m_pricelist_version_id = plv.m_pricelist_version_id INNER JOIN m_pricelist as pl ON pl.m_pricelist_id = plv.m_pricelist_id WHERE pl.issopricelist = 'N' AND pl.isactive = 'Y' AND plv.isactive = 'Y' AND pp.isactive = 'Y' AND (pl.ad_org_id = p.ad_org_id OR pl.ad_org_id = 0) AND pp.m_product_id = p.m_product_id ORDER BY pl.ad_org_id DESC, plv.validfrom DESC LIMIT 1),0) as cost_pricelist
 FROM (SELECT s.ad_client_id, s.ad_org_id, s.m_product_id, s.value, s.name, s.m_product_category_id, s.m_warehouse_id, sum(s.qtyonhand) AS qtyonhand, sum(s.qtyreserved) AS qtyreserved, sum(s.qtyavailable) AS qtyavailable, sum(s.qtyordered) AS qtyordered
   FROM ( SELECT s.ad_client_id, s.ad_org_id, s.m_product_id, p.value, p.name, p.m_product_category_id, l.m_warehouse_id, s.qtyonhand, s.qtyreserved, s.qtyonhand - s.qtyreserved AS qtyavailable, s.qtyordered
           FROM m_storage s
      JOIN m_locator l ON s.m_locator_id = l.m_locator_id
   JOIN m_product p ON s.m_product_id = p.m_product_id) s
  GROUP BY s.ad_client_id, s.ad_org_id, s.m_product_id, s.value, s.name, s.m_product_category_id, s.m_warehouse_id) as p;

ALTER TABLE rv_storage_product_plus OWNER TO libertya;

--20130215-1314 Nueva columna que permite registrar el medio de cobro a crédito 
update ad_system set dummy = (SELECT addcolumnifnotexists('c_invoice','c_pospaymentmedium_credit_id', 'integer'));