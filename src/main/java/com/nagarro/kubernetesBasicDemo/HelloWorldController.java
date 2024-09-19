package com.nagarro.kubernetesBasicDemo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
	
	@GetMapping("/")
	public String helloworld() {
		return "Welcome to Kubernetes";
	}

}
