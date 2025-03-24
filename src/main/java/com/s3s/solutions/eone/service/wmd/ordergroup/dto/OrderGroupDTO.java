package com.s3s.solutions.eone.service.wmd.ordergroup.dto;

import com.s3s.sfp.service.mybatis.DTOKey;
import com.s3s.sfp.SfpConst;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderGroupDTO extends CrudModeDTO {

	@DTOKey("WOG")
	/** 지시그룹번호. */
	private String orderGroupId;
	/** 라인아이디. */
	private String lineNo;
	/** 지시그룹유형. */
	private String orderGroupTypeCd;
	/** 지시그룹일자. */
	private String orderGroupDate;
	/** 긴급여부. */
	private String emergencyYn;
	/** 지시트레이수. */
	private Integer orderTrayQty;
	/** 처리트레이수. */
	private Integer workTrayQty;
	/** 지시그룹시작일시. */
	private String orderGroupStartDt;
	/** 지시그룹완료일시. */
	private String orderGroupEndDt;
	/** 지시그룹상태코드. */
	private String orderGroupStatusCd;
	/** 지시그룹완료유형. */
	private String orderGroupFinishTypeCd;

	public String getOrderGroupTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "order_type_cd", orderGroupTypeCd);
	}

	public String getOrderGroupStatusNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "order_group_status_cd", orderGroupStatusCd);
	}

	public String getOrderGroupFinishTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "order_group_finish_type_cd", orderGroupFinishTypeCd);
	}


}