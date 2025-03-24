package com.s3s.solutions.eone.service.wmd.traylocation;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.apps.define.VariableDefine;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.tools.NumberTools;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.define.ETrayStatus;
import com.s3s.solutions.eone.service.wmd.traylocation.dto.TrayLocationDTO;

import ch.qos.logback.classic.Logger;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TrayLocationVO extends TrayLocationDTO {

	private String mcId;
	private Integer expirationDay;
	private Integer storageDay;
	private String orderTypeCd;
	private String trayStatusCd;
	private String sensor = "0"; // 1 = ON, 0 = OFF
	private int inquiryQty;
	private String rackName;
	private String orderId;
	private String planNo;

	private String usedYn = SfpConst.YN_N;//입고 TRAY 위치 선정시 사용
	private List<String> trayStatusCdList = new ArrayList<>();
	private String sort;
	private String storeRackCount = "0";

	public boolean isDischargePossible() {
		//TRAY가 있는 경우만 배출 가능한지 체크!
		if(StringUtils.isNotEmpty(super.getTrayId())) {
			//센서도 0인 경우만 배출 가능
			if(StringUtils.equals(sensor, "0")) {
				return true;
			}
		}
		return false;
	}

	public int getMaxExpirationDay() {
		return NumberTools.parseInt(MemoryManager.getColumn(SfpConst.SYS_VARIABLE, VariableDefine.mValue, EoneConst.POP_SETTING+"_line"+getLineNo(), EoneConst.MAX_EXPIRATION_DAY), 0);
	}

	public String getExpirationDayOver() {
		if(StringUtils.isEmpty(getTrayId()) || StringUtils.isEmpty(getInputDate()) || StringUtils.isEmpty(String.valueOf(getMaxExpirationDay())) || getStorageDay() == null) {
			return StringUtils.EMPTY;
		}

		if(getMaxExpirationDay() <= getStorageDay()) {
			return "warning";
		}

		return StringUtils.EMPTY;
	}

	public String getTrayStatusText() {
		String type = StringUtils.EMPTY;
		String status = StringUtils.EMPTY;

		if(StringUtils.isNotEmpty(getOrderTypeCd())) {
			type = EOrderType.valueOf(getOrderTypeCd()).getText();
		}

		if(StringUtils.isNotEmpty(getTrayStatusCd())) {
			status = ETrayStatus.valueOf(getTrayStatusCd()).getText();
		}

		if(StringUtils.isNotEmpty(type) && StringUtils.isNotEmpty(status)) {
			return String.format("%s %s", type, status);
		}

		return StringUtils.EMPTY;
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