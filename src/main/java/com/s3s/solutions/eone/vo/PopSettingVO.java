package com.s3s.solutions.eone.vo;

import com.s3s.sfp.service.common.CommonDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PopSettingVO extends CommonDTO {

	private int maxExpirationDay;
	private String continuousType;

}
