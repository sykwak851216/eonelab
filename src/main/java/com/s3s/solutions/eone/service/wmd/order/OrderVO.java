package com.s3s.solutions.eone.service.wmd.order;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import com.microsoft.sqlserver.jdbc.StringUtils;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.NumberTools;
import com.s3s.solutions.eone.service.wmd.order.dto.OrderDTO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderVO extends OrderDTO {

	private String orderGroupTypeCd;

	private int changeWorkTrayQty;

	private List<OrderTrayVO> orderTrayList = new ArrayList<>();

	public void plusWorkTrayQty(int workTrayQty) {
		super.setWorkTrayQty(NumberTools.nullToZero(super.getWorkTrayQty()) + workTrayQty);
	}

	public String getTakeSeconds() {
		String now = DateTools.getDateTimeString();
		String from = StringUtils.isEmpty(getOrderStartDt()) ? now : getOrderStartDt();
		String to = StringUtils.isEmpty(getOrderEndDt()) ? now : getOrderEndDt();
		try {
			return String.valueOf(DateTools.getDiffSecondByYmdhms(from, to));
		} catch (ParseException e) {
			e.printStackTrace();
			return StringUtils.EMPTY;
		}
	}

	public String getOrderStartHms() {
		try {
			if(StringUtils.isEmpty(getOrderStartDt()) == false) {
				return DateTools.changeDateString(getOrderStartDt(), DateTools.YYYYMMDD_HHMMSS, DateTools.HHMMSS);
			}
		} catch (ParseException e) {
			e.printStackTrace();
			return StringUtils.EMPTY;
		}
		return StringUtils.EMPTY;
	}

	public String getOrderEndHms() {
		try {
			if(StringUtils.isEmpty(getOrderEndDt()) == false) {
				return DateTools.changeDateString(getOrderEndDt(), DateTools.YYYYMMDD_HHMMSS, DateTools.HHMMSS);
			}
		} catch (ParseException e) {
			e.printStackTrace();
			return StringUtils.EMPTY;
		}
		return StringUtils.EMPTY;
	}

}