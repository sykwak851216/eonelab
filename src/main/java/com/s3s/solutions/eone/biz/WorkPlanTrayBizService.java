package com.s3s.solutions.eone.biz;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.tools.GeneratorIDTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderKind;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationService;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayService;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayVO;
import com.s3s.solutions.eone.service.wmd.workplantray.dto.WorkPlanTrayDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class WorkPlanTrayBizService {

	private final WorkPlanTrayService workPlanTrayService;
	
	private final TrayLocationService trayLocationService;
	
	public void registerTrayList(List<WorkPlanTrayDTO> list, EOrderGroupType eOrderGroupType, EOrderKind eOrderKind) throws Exception {
		for (WorkPlanTrayDTO plan : list) {
			TrayLocationVO trayLocationVO = trayLocationService.getDetail(new TrayLocationVO() {{
				setTrayId(plan.getTrayId());
			}});
			plan.setPlanGroupNo(GeneratorIDTools.getId("WWPRT"));
			plan.setLineNo(trayLocationVO.getLineNo());
			plan.setRackCellXAxis(trayLocationVO.getRackCellXAxis());
			plan.setRackCellYAxis(trayLocationVO.getRackCellYAxis());
			plan.setRackId(trayLocationVO.getRackId());
		}
		workPlanTrayService.registerTrayList(list, eOrderGroupType, eOrderKind);
	}
	
	@Transactional(rollbackFor = { Exception.class })
	public Map<String, Object> registerWaitTrayList(List<WorkPlanTrayVO> list) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int failTrayCnt = 0;
		String planGroupNo = GeneratorIDTools.getId("WWPRT");
		
		for (WorkPlanTrayVO plan : list) {
			//렉에 있는 트레이 인지 확인
			List<TrayLocationVO> trayLocationVOList = trayLocationService.getList(new TrayLocationVO() {{
				setTrayId(plan.getTrayId());
			}});
			
			if (ListTools.isNullOrEmpty(trayLocationVOList)) {
				failTrayCnt++;
				plan.setValidateResult("존재하지 않는 Rack번호 입니다.");
			} else if(ListTools.getSize(trayLocationVOList) > 1) {
				failTrayCnt++;
				plan.setValidateResult("한개 이상 존재하는 Rack번호 입니다. 좀더 정확히 입력하세요.");
			} else {
				TrayLocationVO trayLocationVO = trayLocationVOList.get(0);
				plan.setTrayId(trayLocationVO.getTrayId());
				//이미 대기 목록에 있는지 확인
				if(workPlanTrayService.isRegistedTray(plan.getTrayId())) {
					failTrayCnt++;
					plan.setValidateResult("이미 대기 Rack에 등록된 Rack 번호 입니다.");
				}
				
				plan.setPlanGroupNo(planGroupNo);
				plan.setLineNo(trayLocationVO.getLineNo());
				plan.setRackCellXAxis(trayLocationVO.getRackCellXAxis());
				plan.setRackCellYAxis(trayLocationVO.getRackCellYAxis());
				plan.setRackId(trayLocationVO.getRackId());
				plan.setInputDate(trayLocationVO.getInputDate());
				plan.setStorageDay(trayLocationVO.getStorageDay());
			}
		}
		
		if (failTrayCnt == 0) {
			workPlanTrayService.registerWaitTrayList(list);
			resultMap.put("result", "200");
		} else {
			resultMap.put("result", "500");
			resultMap.put("list", list);
		}
		return resultMap;
	}
	


}