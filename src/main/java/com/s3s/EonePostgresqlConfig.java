package com.s3s;

import javax.sql.DataSource;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariDataSource;

@Configuration
@MapperScan(basePackages = {"com.s3s.sfp.apps", "com.s3s.solutions.eone"}, annotationClass = Mapper.class, sqlSessionFactoryRef = "sqlSessionFactory.postgresql")
@EnableTransactionManagement
public class EonePostgresqlConfig {

	@Bean("config.postgresql")
	@ConfigurationProperties(prefix = "sfp.mybatis.postgresql.configuration")
	public org.apache.ibatis.session.Configuration myBatisConfig() {
		return new org.apache.ibatis.session.Configuration();
	}

	@Primary
	@Bean(name = "dataSource.postgresql", destroyMethod = "close")
	@ConfigurationProperties(prefix = "spring.datasource.postgresql")
	public DataSource dataSource(
			@Value("${spring.datasource.postgresql.hikari.maximum-pool-size:20}") Integer maximumPoolSize
			, @Value("${spring.datasource.postgresql.hikari.minimum-idle:10}") Integer minimumIdle
			, @Value("${spring.datasource.postgresql.hikari.connection-timeout:5000}") Long connectionTimeout) {
		HikariDataSource dataSource = new HikariDataSource();
		dataSource.setMinimumIdle(maximumPoolSize);
		dataSource.setMaximumPoolSize(minimumIdle);
		dataSource.setConnectionTimeout(connectionTimeout);
		return dataSource;
	}

	@Primary
	@Bean(name = "sqlSessionFactory.postgresql")
	public SqlSessionFactory sqlSessionFactory(
			@Qualifier("dataSource.postgresql") DataSource dataSource,
			@Qualifier("config.postgresql") org.apache.ibatis.session.Configuration config,
			@Value("${spring.datasource.postgresql.mapper-location}") String mapperLocation,
			ApplicationContext applicationContext) throws Exception {
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(dataSource);
		sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources(mapperLocation));
		sqlSessionFactoryBean.setConfiguration(config);
		return sqlSessionFactoryBean.getObject();
	}

	@Primary
	@Bean(name = "sqlSessionTemplate.postgresql")
	public SqlSessionTemplate sqlSessionTemplateEone(@Qualifier("sqlSessionFactory.postgresql") SqlSessionFactory sqlSessionFactory) throws Exception {
		return new SqlSessionTemplate(sqlSessionFactory);
	}

	@Primary
	@Bean(name = "transactionManager")
	public PlatformTransactionManager transactionManager(@Qualifier("dataSource.postgresql") DataSource dataSource) {
		return new DataSourceTransactionManager(dataSource);
	}


}