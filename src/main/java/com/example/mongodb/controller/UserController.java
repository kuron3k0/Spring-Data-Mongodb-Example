package com.example.mongodb.controller;

import com.example.mongodb.model.User;
import com.example.mongodb.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

@RestController
@RequestMapping("/v1/user")
public class UserController {

   @Autowired
   private UserRepository userRepository;
   
   @ResponseStatus(HttpStatus.CREATED)
   @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
   public User createUser(@RequestBody User user) {
      return userRepository.save(user);
   }

   @PostMapping(value="/get")
   public User readUserById(@RequestBody String id) throws UnsupportedEncodingException {
      System.out.println(URLDecoder.decode(id, "utf-8"));
      return userRepository.findByUserNameLike(URLDecoder.decode(id, "utf-8"));
   }
   

   



}
