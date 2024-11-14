package com.spring.app;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest
class SpringBootJenkinsPipelineApplicationTests {

	@Test
	void contextLoads() {
		assertThat(true).isTrue();
	}

}
