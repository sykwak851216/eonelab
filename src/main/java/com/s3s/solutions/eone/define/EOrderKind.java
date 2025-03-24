package com.s3s.solutions.eone.define;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum EOrderKind {
	INTERFACE("IF"), HADNWRITE("수기");

	private String text;
	EOrderKind(String text) {
		this.text = text;
	}
}
