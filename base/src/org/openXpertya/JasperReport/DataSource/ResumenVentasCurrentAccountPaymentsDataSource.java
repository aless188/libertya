package org.openXpertya.JasperReport.DataSource;

import java.sql.Timestamp;
import java.util.Properties;

public class ResumenVentasCurrentAccountPaymentsDataSource extends
		ResumenVentasPaymentMediumDataSource {

	public ResumenVentasCurrentAccountPaymentsDataSource(String trxName,
			Properties ctx, Integer orgID, Timestamp dateFrom,
			Timestamp dateTo, Integer posID, Integer userID) {
		super(trxName, ctx, orgID, dateFrom, dateTo, posID, userID);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected String getDSWhereClause() {
		return " AND trxtype = 'PCA' ";
	}
}
