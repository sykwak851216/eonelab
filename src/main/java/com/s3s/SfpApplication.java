package com.s3s;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Configuration;

import com.s3s.sfp.dmw.config.EnableDMW;
import com.s3s.sfp.settings.SfpBeanNameGenerator;
import com.s3s.sfp.settings.dmw.DBConfiguration;

@SpringBootApplication
@Configuration
//PLC 통신을 위해선 주석을 삭제 하셔야 합니다.
@EnableDMW(configuration = DBConfiguration.class)
public class SfpApplication extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(SfpApplication.class).beanNameGenerator(new SfpBeanNameGenerator());
	}

	public static void main(String[] args) {
		new SpringApplicationBuilder(SfpApplication.class).beanNameGenerator(new SfpBeanNameGenerator()).run(args);
	}
	
}