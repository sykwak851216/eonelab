package com.s3s.solutions.eone.service.wmd.rackcell;

import org.apache.commons.lang3.StringUtils;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.apps.define.VariableDefine;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.tools.NumberTools;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.service.wmd.rackcell.dto.RackCellDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RackCellVO extends RackCellDTO {

	private String mcId;
	private String lineNo;
	private String trayId;
	private String inputDate;//입고일
	private Integer storageDay;//보관일

	public int getMaxExpirationDay() {
		return NumberTools.parseInt(MemoryManager.getColumn(SfpConst.SYS_VARIABLE, VariableDefine.mValue, EoneConst.POP_SETTING+"_line"+getLineNo(), EoneConst.MAX_EXPIRATION_DAY), 0);
	}

	public String getExpirationDayOver() {
		if(StringUtils.isEmpty(trayId) || StringUtils.isEmpty(inputDate) || getStorageDay() == null) {
			return StringUtils.EMPTY;
		}

		if(getMaxExpirationDay() <= getStorageDay()) {
			return "warning";
		}

		return StringUtils.EMPTY;
	}
	
	public String getShowPopTrayId() {
		if (StringUtils.isNotBlank(this.getTrayId())) {
			if (this.getTrayId().length() > 0 && this.getTrayId().length() > 4) {
				trayId = this.getTrayId().substring(this.getTrayId().length()-4, this.getTrayId().length());
			}
		}
		return trayId;
	}

}