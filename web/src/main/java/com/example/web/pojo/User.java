package com.example.web.pojo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

@ApiModel("用户实体类")
@Data
@EqualsAndHashCode(callSuper = false)
public class User {

/*  JavaBean是一个遵循特定写法的Java类，它通常具有如下特点：
    这个Java类必须具有一个无参的构造函数
    属性必须私有化。
    私有化的属性必须通过public类型的方法暴露给其它程序，并且方法的命名也必须遵守一定的命名规范*/
    @ApiModelProperty("用户id")
    private Integer id;

    @ApiModelProperty("用户名")
    private String loginName;

    @ApiModelProperty("密码")
    private String password;



}