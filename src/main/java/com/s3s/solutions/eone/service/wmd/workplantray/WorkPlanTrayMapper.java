package com.s3s.solutions.eone.service.wmd.workplantray;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.workplantray.dto.WorkPlanTrayDTO;

@Mapper
public interface WorkPlanTrayMapper extends DefaultMapper<WorkPlanTrayDTO>{

	public List<WorkPlanTrayVO> selectWorkPlanTrayList(@Param("param") WorkPlanTrayVO workPlanTrayVO);

	public int maxTrayOrderSort(@Param("param") WorkPlanTrayVO workPlanTrayVO);

	public int doEmergency(@Param("param") WorkPlanTrayVO workPlanTrayVO);

	public int deleteWorkPlantray(@Param("param") WorkPlanTrayVO workPlanTrayVO);

	public void updateCompleteWorkPlanTrayListByPlanNo(@Param("param") WorkPlanTrayVO workPlanTrayVO);

	public WorkPlanTrayVO selectTrayInfoReadyIng(@Param("trayId") String trayId);
	
	public List<WorkPlanTrayVO> selectContinuousFistOrderByLineNo(@Param("lineNo") String lineNo);
	
	public int selectTotalCountWorkPlanTrayLimitListByLineNo(@Param("param") WorkPlanTrayVO workPlanTrayVO);
	
	public List<WorkPlanTrayVO> selectWorkPlanTrayLimitListByLineNo(@Param("param") WorkPlanTrayVO workPlanTrayVO, @Param("paging") PagingDTO workPaging);
	
	public List<WorkPlanTrayVO> selectInterfaceOrderTrayList(@Param("planNo") String planNo, @Param("lineNo") String lineNo, @Param("orderId") String orderId);
	
}