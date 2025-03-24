package com.s3s.solutions.eone.service.wmd.orderwork;

import org.apache.commons.lang3.StringUtils;

import com.s3s.solutions.eone.define.EInOutType;
import com.s3s.solutions.eone.service.wmd.orderwork.dto.OrderWorkDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderWorkVO extends OrderWorkDTO {

	private String orderGroupId;
	private String rackName;
	private String inputDate;

	public String getFromLocation() {
		return StringUtils.equalsIgnoreCase(getInOutTypeCd(), EInOutType.INPUT.name()) ? reNameBufferId() : getRackCellName();
	}

	public String getToLocation() {
		return StringUtils.equalsIgnoreCase(getInOutTypeCd(), EInOutType.INPUT.name()) ? getRackCellName() : reNameBufferId();
	}

	public String getRackCellName() {
		if(StringUtils.isEmpty(getRackId())) {
			return "discharge";
		}else {
			return getRackNameCache() + "/" + getRackCellXAxis() + "/" + getRackCellYAxis();
		}
	}

	public String reNameBufferId() {
		return "BC-"+StringUtils.leftPad(getBufferId(), 3, "0");
	}
	
	public String getShowPopTrayId() {
		String trayId = getTrayId();
		if (StringUtils.isNotBlank(getTrayId())) {
			if (trayId.length() > 0 && trayId.length() > 4) {
				trayId = trayId.substring(trayId.length()-4, trayId.length());
			}
		}
		return trayId;
	}

}