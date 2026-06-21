package top.xiaocaohub.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import top.xiaocaohub.entity.User;
import top.xiaocaohub.mapper.UserMapper;
import top.xiaocaohub.service.UserService;
import top.xiaocaohub.utils.Md5Util;

// 标记为 Service 类
@Service
public class UserServiceImpl implements UserService {

    // 自动注入 UserMapper
    @Autowired
    private UserMapper userMapper;

    @Override
    public User register(String username, String password, String realName, String email, String phone) {
        // 1. 检查用户名是否已存在
        // LambdaQueryWrapper : MyBatis-Plus 的条件构造器
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username);
        if (userMapper.selectOne(wrapper) != null) {
            throw new RuntimeException("用户名已存在");
        }

        // 2. 创建用户对象
        User user = new User();
        user.setUsername(username);
        user.setPassword(Md5Util.encrypt(password));  // MD5加密
        user.setRealName(realName);
        user.setEmail(email);
        user.setPhone(phone);

        // 3. 插入数据库
        userMapper.insert(user);

        return user;
    }

    @Override
    public User login(String username, String password) {
        // 1. 根据用户名查询
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username);
        User user = userMapper.selectOne(wrapper);

        // 2. 验证用户是否存在
        if (user == null) {
            throw new RuntimeException("用户名不存在");
        }

        // 3. 验证密码
        if (!user.getPassword().equals(Md5Util.encrypt(password))) {
            throw new RuntimeException("密码错误");
        }

        return user;
    }

    @Override
    public User getUserById(Integer id) {
        return userMapper.selectById(id);
    }

    @Override
    public void updateUserInfo(Integer id, String realName, String email, String phone) {
        User user = new User();
        user.setId(id);
        user.setRealName(realName);
        user.setEmail(email);
        user.setPhone(phone);
        userMapper.updateById(user);
    }

    @Override
    public void updatePassword(Integer id, String oldPassword, String newPassword) {
        // 1. 查询用户
        User user = userMapper.selectById(id);

        // 2. 验证旧密码
        if (!user.getPassword().equals(Md5Util.encrypt(oldPassword))) {
            throw new RuntimeException("原密码错误");
        }

        // 3. 更新密码
        User updateUser = new User();
        updateUser.setId(id);
        updateUser.setPassword(Md5Util.encrypt(newPassword));
        userMapper.updateById(updateUser);
    }

    @Override
    public void updateAvatar(Integer id, String avatar) {
        User user = new User();
        user.setId(id);
        user.setAvatar(avatar);
        userMapper.updateById(user);
    }
}
