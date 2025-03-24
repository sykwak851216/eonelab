package com.s3s.solutions.eone.vo;

import java.util.ArrayList;
import java.util.List;

import com.s3s.sfp.service.common.CommonDTO;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.dmw.command.PLCCommand;
import com.s3s.solutions.eone.dmw.command.message.body.GantryReportBody;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayVO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PopMainVO extends CommonDTO {
	private String lineNo;
	private PopSettingVO popSetting;
	private OrderGroupVO orderGroup;
	private List<TrayLocationVO> storageTrayList = new ArrayList<>();
	private List<TrayLocationVO> lineStorageCount = new ArrayList<>();
	private List<WorkPlanTrayVO> outputRegistedTrayList = new ArrayList<>();
	private List<WorkPlanTrayVO> inquiryRegistedTrayList = new ArrayList<>();
	private List<TrayLocationVO> bufferList = new ArrayList<>();
	private List<OrderOperationHistoryVO> orderOperationHistoryList = new ArrayList<>();
	private List<OrderWorkVO> orderWorkList = new ArrayList<>();
	private GantryReportBody gantryReportBody = new GantryReportBody();
	private List<TrayLocationVO> lineBufferCount = new ArrayList<>();
	private long lineBufferCensingOnCount = 0;

	public int getStorageTrayListCount() {
		return ListTools.getSize(storageTrayList);
	}

	public int getOutputRegistedTrayCount() {
		return ListTools.getSize(outputRegistedTrayList);
	}

	public int getInquiryRegistedTrayCount() {
		return ListTools.getSize(inquiryRegistedTrayList);
	}
//
//	public boolean isBufferOnWorkingstation() {
//		return PLCCommand.isBufferOnWorkingstation(this.lineNo);
//	}
//
	public String getBufferPosition() {
		return PLCCommand.getBufferPosition(this.lineNo);
	}
}
