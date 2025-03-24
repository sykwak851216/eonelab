package com.s3s.solutions.eone.controller.wmd;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.solutions.eone.biz.WorkPlanTrayBizService;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderKind;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayService;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayVO;
import com.s3s.solutions.eone.service.wmd.workplantray.dto.WorkPlanTrayDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("작업 계획 트레이")
@RequestMapping(value = "/solutions/eone/wmd/workplantray")
public class WorkPlanTrayController {

	private final WorkPlanTrayService workPlanTrayService;
	
	private final WorkPlanTrayBizService workPlanTrayBizService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<WorkPlanTrayVO> getPagingList(WorkPlanTrayVO vo, PagingDTO page) throws Exception {
		return workPlanTrayService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<WorkPlanTrayDTO> getList(WorkPlanTrayDTO vo) throws Exception {
		return workPlanTrayService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(WorkPlanTrayDTO vo) throws Exception {
		workPlanTrayService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(WorkPlanTrayDTO vo) throws Exception {
		workPlanTrayService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(WorkPlanTrayDTO vo) throws Exception {
		workPlanTrayService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<WorkPlanTrayDTO> list) throws Exception {
		workPlanTrayService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<WorkPlanTrayDTO> list) throws Exception {
		workPlanTrayService.deleteList(list);
	}

	@RequestMapping(value = { "/getWorkPlanTrayList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<WorkPlanTrayVO> getList(WorkPlanTrayVO vo) throws Exception {
		return workPlanTrayService.getWorkPlanTrayList(vo);
	}
	
	@RequestMapping(value = { "/getWorkPlanTrayListByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<WorkPlanTrayVO> getWorkPlanTrayListByLineNo(WorkPlanTrayVO vo) throws Exception {
		return workPlanTrayService.getWorkPlanTrayList(vo);
	}

	@RequestMapping(value = "/registerOutputTrayList", method = { RequestMethod.GET, RequestMethod.POST })
	public void registerOutputTrayList(@RequestBody List<WorkPlanTrayDTO> list) throws Exception {
		
		workPlanTrayBizService.registerTrayList(list, EOrderGroupType.OUTPUT, EOrderKind.HADNWRITE);
	}

	@RequestMapping(value = "/registerInquiryTrayList", method = { RequestMethod.GET, RequestMethod.POST })
	public void registerInquiryTrayList(@RequestBody List<WorkPlanTrayDTO> list) throws Exception {
		
		workPlanTrayBizService.registerTrayList(list, EOrderGroupType.INQUIRY, EOrderKind.HADNWRITE);
	}
	
	@RequestMapping(value = "/registerWaitTrayList", method = { RequestMethod.GET, RequestMethod.POST })
	public Map<String, Object> registerWaitTrayList(@RequestBody List<WorkPlanTrayVO> list) throws Exception {
		return workPlanTrayBizService.registerWaitTrayList(list);
	}

	@RequestMapping(value = "/doEmergencyList", method = { RequestMethod.GET, RequestMethod.POST })
	public void doEmergencyList(@RequestBody WorkPlanTrayVO vo) throws Exception {
		workPlanTrayService.doEmergencyList(vo);
	}

	@RequestMapping(value = "/deleteWorkPlantray", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteWorkPlantray(@RequestBody WorkPlanTrayVO vo) throws Exception {
		workPlanTrayService.deleteWorkPlantray(vo);
	}

}