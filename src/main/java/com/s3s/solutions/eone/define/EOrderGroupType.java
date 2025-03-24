package com.s3s.solutions.eone.define;

import lombok.Getter;

@Getter
public enum EOrderGroupType {
	INPUT("보관업무"), OUTPUT("폐기업무"), INQUIRY("호출업무");

	private String text;

	private EOrderGroupType(String text) {
		this.text = text;
	}

}
