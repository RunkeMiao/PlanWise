package top.xiaocaohub.service;

import top.xiaocaohub.entity.User;

public interface UserService {

    /**
     * 用户注册
     */
    User register(String username, String password, String realName, String email, String phone);

    /**
     * 用户登录
     */
    User login(String username, String password);

    /**
     * 根据ID获取用户信息
     */
    User getUserById(Integer id);

    /**
     * 修改个人信息
     */
    void updateUserInfo(Integer id, String realName, String email, String phone);

    /**
     * 修改密码
     */
    void updatePassword(Integer id, String oldPassword, String newPassword);

    /**
     * 更新头像
     */
    void updateAvatar(Integer id, String avatar);
}
