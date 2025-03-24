package com.s3s.solutions.eone.service.wmd.workplantray;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.apps.define.VariableDefine;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.tools.NumberTools;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.define.EOrderKind;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.service.wmd.workplantray.dto.WorkPlanTrayDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WorkPlanTrayVO extends WorkPlanTrayDTO {

	private Integer storageDay;
	private List<String> planNoList = new ArrayList<>();
	private String validateResult;

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
	
	public String getOrderTypeNameCache() {
		if(StringUtils.isEmpty(getOrderTypeCd())) {
			return StringUtils.EMPTY;
		}
		return EOrderType.valueOf(getOrderTypeCd()).getText();
	}
	
	
	public String getOrderKindNameCache() {
		if(StringUtils.isEmpty(getOrderKindCd())) {
			return StringUtils.EMPTY;
		}
		return EOrderKind.valueOf(getOrderKindCd()).getText();
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