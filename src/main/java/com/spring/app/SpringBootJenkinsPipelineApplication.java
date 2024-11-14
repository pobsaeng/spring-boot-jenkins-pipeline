package com.spring.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class SpringBootJenkinsPipelineApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootJenkinsPipelineApplication.class, args);
	}

}

@RestController
class HelloController {
	@GetMapping("/hello")
	public String hello() {
		return "Hello, World!";
	}
}