package com.s3s.solutions.eone.controller.pop;

import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.solutions.eone.biz.OrderOperationHistoryBizService;
import com.s3s.solutions.eone.biz.PopBizService;
import com.s3s.solutions.eone.biz.RackBizService;
import com.s3s.solutions.eone.dmw.command.PLCCommand;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.rack.RackVO;
import com.s3s.solutions.eone.service.wmd.rackcell.RackCellVO;
import com.s3s.solutions.eone.vo.PopMainVO;
import com.s3s.solutions.eone.vo.PopSettingVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("POP메인")
@RequestMapping(value = "/solutions/eone/pop")
public class PopController {

	private final PopBizService popBizService;
	private final RackBizService rackBizService;
	private final OrderOperationHistoryBizService orderOperationHistoryBizService;
	
	@RequestMapping(value = { "/getPopMainInit" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PopMainVO getPopMainInit(@RequestParam(value="lineNo",defaultValue = "") String lineNo) throws Exception {
		return popBizService.getPopMainInitByLineNo(lineNo);
	}

	@RequestMapping(value = { "/getSystemSetting" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PopSettingVO getSystemSetting(@RequestParam(value="lineNo",defaultValue = "") String lineNo) throws Exception {
		return popBizService.getPopSettingData(lineNo);
	}

	/*
	@RequestMapping(value = { "/isBufferOnWorkingstation" }, method = { RequestMethod.POST, RequestMethod.GET })
	public boolean isBufferOnWorkingstation() throws Exception {
		return popBizService.isBufferOnWorkingstation();
	}
	*/
	
	@RequestMapping(value = { "/isBufferOnWorkingstationByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public boolean isBufferOnWorkingstationByLineNo(@RequestParam(value="lineNo",defaultValue = "") String lineNo) throws Exception {
		return popBizService.isBufferOnWorkingstationByLineNo(lineNo);
	}

	@RequestMapping(value = { "/getCellListByGantry" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<RackVO> getCellListByGantry(RackCellVO vo) throws Exception {
		return rackBizService.getCellListByRackId(vo);
	}
	
	@RequestMapping(value = { "/getCellListByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<RackVO> getCellListByLineNo(RackCellVO vo) throws Exception {
		return rackBizService.getCellListByLineNo(vo);
	}

	/*
	@RequestMapping(value = { "/getPlcReportData" }, method = { RequestMethod.POST, RequestMethod.GET })
	public Map<String, Object> getPlcReportData() throws Exception {
		return popBizService.getPlcReportData();
	}
	*/
	
	@RequestMapping(value = { "/isCallOrderByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public String isCallOrderByLineNo(@RequestParam(value="lineNo",defaultValue = "") String lineNo) throws Exception {
		return PLCCommand.isCallOrderByLineNo(lineNo);
	}
	
	@RequestMapping(value = { "/isCallOUTByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public String isCallOUTByLineNo(@RequestParam(value="lineNo",defaultValue = "") String lineNo) throws Exception {
		return PLCCommand.isCallOUTByLineNo(lineNo);
	}
	
	@RequestMapping(value = { "/isDialogOpenStatus" }, method = { RequestMethod.POST, RequestMethod.GET })
	public boolean isDialogOpenStatus(OrderVO orderVO) throws Exception {
		return orderOperationHistoryBizService.isDialogOpenStatus(orderVO);
	}

}