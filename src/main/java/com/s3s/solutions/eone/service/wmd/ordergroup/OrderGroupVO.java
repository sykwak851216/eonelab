package com.s3s.solutions.eone.service.wmd.ordergroup;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import com.microsoft.sqlserver.jdbc.StringUtils;
import com.s3s.sfp.tools.DateTools;
import com.s3s.solutions.eone.define.EOrderGroupFinishStatus;
import com.s3s.solutions.eone.define.EOrderGroupStatus;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.dto.OrderGroupDTO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderGroupVO extends OrderGroupDTO {

	private OrderVO ingOrder = new OrderVO();
	private List<OrderVO> orderList = new ArrayList<>();
	private List<OrderTrayVO> orderTrayList = new ArrayList<>();
	private String searchTrayId;

	public String getTakeSeconds() {
		String now = DateTools.getDateTimeString();
		String from = StringUtils.isEmpty(getOrderGroupStartDt()) ? now : getOrderGroupStartDt();
		String to = StringUtils.isEmpty(getOrderGroupEndDt()) ? now : getOrderGroupEndDt();
		try {
			return String.valueOf(DateTools.getDiffSecondByYmdhms(from, to));
		} catch (ParseException e) {
			e.printStackTrace();
			return StringUtils.EMPTY;
		}
	}

	public String getOrderGroupStartHms() {
		try {
			if(StringUtils.isEmpty(getOrderGroupStartDt()) == false) {
				return DateTools.changeDateString(getOrderGroupStartDt(), DateTools.YYYYMMDD_HHMMSS, DateTools.HHMMSS);
			}
		} catch (ParseException e) {
			e.printStackTrace();
			return StringUtils.EMPTY;
		}
		return StringUtils.EMPTY;
	}

	public String getOrderGroupEndHms() {
		try {
			if(StringUtils.isEmpty(getOrderGroupEndDt()) == false) {
				return DateTools.changeDateString(getOrderGroupEndDt(), DateTools.YYYYMMDD_HHMMSS, DateTools.HHMMSS);
			}
		} catch (ParseException e) {
			e.printStackTrace();
			return StringUtils.EMPTY;
		}
		return StringUtils.EMPTY;
	}

}