package com.s3s;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariDataSource;

@Configuration
@MapperScan(basePackages = {"com.s3s.solutions.eone"}, annotationClass = OracleConnMapper.class, sqlSessionFactoryRef = "sqlSessionFactory.oracle")
@EnableTransactionManagement
public class EoneOracleConfig {

	@Bean("config.oracle")
	@ConfigurationProperties(prefix = "sfp.mybatis.oracle.configuration")
	public org.apache.ibatis.session.Configuration myBatisConfig() {
		return new org.apache.ibatis.session.Configuration();
	}

	@Bean(name = "dataSource.oracle", destroyMethod = "close")
	@ConfigurationProperties(prefix = "spring.datasource.oracle")
	public DataSource dataSource(
			@Value("${spring.datasource.oracle.hikari.maximum-pool-size:10}") Integer maximumPoolSize
			, @Value("${spring.datasource.oracle.hikari.minimum-idle:5}") Integer minimumIdle
			, @Value("${spring.datasource.postgresql.hikari.connection-timeout:5000}") Long connectionTimeout) {
		HikariDataSource dataSource = new HikariDataSource();
		dataSource.setMinimumIdle(minimumIdle);
		dataSource.setMaximumPoolSize(maximumPoolSize);
		dataSource.setConnectionTimeout(connectionTimeout);
		return dataSource;
	}

	@Bean(name = "sqlSessionFactory.oracle")
	public SqlSessionFactory sqlSessionFactory(
			@Qualifier("dataSource.oracle") DataSource dataSource,
			@Qualifier("config.oracle") org.apache.ibatis.session.Configuration config,
			@Value("${spring.datasource.oracle.mapper-location}") String mapperLocation,
			ApplicationContext applicationContext) throws Exception {
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(dataSource);
		sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources(mapperLocation));
		sqlSessionFactoryBean.setConfiguration(config);
		return sqlSessionFactoryBean.getObject();
	}

	@Bean(name = "sqlSessionTemplate.oracle")
	public SqlSessionTemplate sqlSessionTemplateEone(@Qualifier("sqlSessionFactory.oracle") SqlSessionFactory sqlSessionFactory) throws Exception {
		return new SqlSessionTemplate(sqlSessionFactory);
	}

	@Bean(name = "transactionManager.oracle")
	public PlatformTransactionManager transactionManager(@Qualifier("dataSource.oracle") DataSource dataSource) {
		return new DataSourceTransactionManager(dataSource);
	}

}