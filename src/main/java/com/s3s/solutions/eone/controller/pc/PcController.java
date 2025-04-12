package com.s3s.solutions.eone.controller.pc;

import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.apps.define.VariableDefine;
import com.s3s.sfp.manager.memory.MemoryManager;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.biz.InterfaceBizService;
import com.s3s.solutions.eone.exchange.job.JobService;
import com.s3s.solutions.eone.exchange.job.JobVO;
import com.s3s.solutions.eone.exchange.jobtray.JobTrayService;
import com.s3s.solutions.eone.exchange.jobtray.JobTrayVO;
import com.s3s.solutions.eone.exchange.workjobtray.WorkJobTrayService;
import com.s3s.solutions.eone.exchange.workjobtray.WorkJobTrayVO;
import com.s3s.solutions.eone.manager.OrderManager;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("PC메인")
@RequestMapping(value = "/solutions/eone/pc")
public class PcController {
	private final InterfaceBizService interfaceBizService;
	
	private final JobService jobService;
	
	private final JobTrayService jobTrayService;
	
	private final WorkJobTrayService workJobTrayService;
	
	private final OrderManager orderManager;
	
	@RequestMapping(value = { "/test" }, method = { RequestMethod.POST, RequestMethod.GET })
	public void test() throws Exception {
		//System.out.println(MemoryManager.getColumn(SfpConst.SYS_VARIABLE, VariableDefine.mValue, EoneConst.POP_SETTING+"_line1", EoneConst.MAX_EXPIRATION_DAY));
		interfaceBizService.procYudoList();
	}
	
	@RequestMapping(value = { "/getYudoList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<JobVO> getYudoList(JobVO vo) throws Exception {
		return jobService.getList(vo);
	}
	
	@RequestMapping(value = { "/getYudoTrayList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<JobTrayVO> getYudoTrayList(JobTrayVO vo) throws Exception {
		return jobTrayService.getList(vo);
	}
	
	@RequestMapping(value = { "/getYudoWorkPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<WorkJobTrayVO> getYudoWorkPagingList(WorkJobTrayVO vo, PagingDTO page) throws Exception {
		return workJobTrayService.getYudoWorkPagingList(vo, page);
	}
	
	@RequestMapping(value = { "/input" }, method = { RequestMethod.POST, RequestMethod.GET })
	public void input() throws Exception {
		orderManager.taskOrder();
	}

}