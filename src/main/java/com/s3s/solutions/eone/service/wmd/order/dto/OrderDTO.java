package com.s3s.solutions.eone.service.wmd.order.dto;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.service.common.CrudModeDTO;
import com.s3s.sfp.service.mybatis.DTOKey;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderDTO extends CrudModeDTO {

	@DTOKey("")
	/** 지시번호. */
	private String orderId;
	/** 지시그룹유형. */
	private String orderGroupId;
	/** 지시유형. */
	private String orderTypeCd;
	/** 지시일자. */
	private String orderDate;
	/** 지시트레이수. */
	private Integer orderTrayQty;
	/** 처리트레이수. */
	private Integer workTrayQty;
	/** 시작일시. */
	private String orderStartDt;
	/** 완료일시. */
	private String orderEndDt;
	/** 지시상태. */
	private String orderStatusCd;
	/** 완료유형. */
	private String orderFinishTypeCd;
	/** 라인번호. */
	private String lineNo;

	public String getOrderTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "order_type_cd", orderTypeCd);
	}

	public String getOrderStatusNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "order_status_cd", orderStatusCd);
	}

	public String getOrderFinishTypeNameCache() {
		return MemoryManager.getColumn(SfpConst.SYS_CODE_SLAVE, "slave_name", "order_finish_status_cd", orderFinishTypeCd);
	}

}