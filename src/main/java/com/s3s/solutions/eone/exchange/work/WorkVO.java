package com.s3s.solutions.eone.exchange.work;

import java.util.List;

import com.s3s.solutions.eone.exchange.work.dto.WorkDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WorkVO extends WorkDTO {
	private List<WorkReadTrayVO> workTrayList;
	
	
}
