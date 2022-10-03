package com.example.web.controller;

import com.example.web.pojo.User;
import com.example.web.service.UserService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    //判断是否存在
//    public boolean isExist(String loginName){
//        return userService.getByLoginName(loginName) != null?true:false;
//    }


    //查询所有用户信息
    @ApiOperation("查询所有用户信息")
    @GetMapping("/getUserAll")
    public List<User> getUserAll() {
        return userService.getUserAll();
    }

    //新增用户
    @ApiOperation("新增用户")
    @PostMapping("/addUser")
    public String addUser(@RequestBody User user) {
        if(userService.addUser(user) != true){
            return "用户已存在！";
        }else{
            return "注册成功！";
        }

    }

    //更新用户
    @ApiOperation("修改用户通过id")
    @PutMapping("/updateUser")
    public String updateUser(@RequestBody User user) {
        if (userService.updateUser(user) == true) {
            return "更新成功";
        } else {
            return "更新失败";
        }
    }

    //删除
    @ApiOperation("删除用户通过id")
    @DeleteMapping("/deleteUser")
    public String deleteUser(Integer id) {
        if (userService.deleteUser(id) == true) {
            return "删除成功！";
        } else {
            return "删除成功";
        }
    }

}
