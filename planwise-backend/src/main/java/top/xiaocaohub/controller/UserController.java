package top.xiaocaohub.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import top.xiaocaohub.common.Result;
import top.xiaocaohub.entity.User;
import top.xiaocaohub.service.UserService;
import top.xiaocaohub.utils.JwtUtil;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    /**
     * 用户注册
     * POST /api/user/register
     */
    @PostMapping("/register")
    public Result<?> register(@RequestBody Map<String, String> params) {
        String username = params.get("username");
        String password = params.get("password");
        String email = params.get("email");
        String phone = params.get("phone");

        try {
            User user = userService.register(username, password, email, phone);

            Map<String, Object> data = new HashMap<>();
            data.put("id", user.getId());
            data.put("username", user.getUsername());

            return Result.success("注册成功", data);
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }

    /**
     * 用户登录
     * POST /api/user/login
     */
    @PostMapping("/login")
    public Result<?> login(@RequestBody Map<String, String> params) {
        String username = params.get("username");
        String password = params.get("password");

        try {
            User user = userService.login(username, password);

            // 生成 Token
            String token = jwtUtil.generateToken(user.getId(), user.getUsername());

            // 构建响应数据
            Map<String, Object> userData = new HashMap<>();
            userData.put("id", user.getId());
            userData.put("username", user.getUsername());
            userData.put("email", user.getEmail());
            userData.put("phone", user.getPhone());
            userData.put("avatar", user.getAvatar());

            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", userData);

            return Result.success("登录成功", data);
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }

    /**
     * 获取当前用户信息
     * GET /api/user/info
     */
    @GetMapping("/info")
    public Result<?> getUserInfo(@RequestHeader("Authorization") String authorization) {
        try {
            // 解析 Token
            String token = authorization.replace("Bearer ", "");
            Integer userId = jwtUtil.getUserIdFromToken(token);

            // 查询用户信息
            User user = userService.getUserById(userId);
            if (user == null) {
                return Result.error(401, "用户不存在");
            }

            // 构建响应（不返回密码）
            Map<String, Object> data = new HashMap<>();
            data.put("id", user.getId());
            data.put("username", user.getUsername());
            data.put("email", user.getEmail());
            data.put("phone", user.getPhone());
            data.put("avatar", user.getAvatar());
            data.put("createTime", user.getCreateTime());

            return Result.success(data);
        } catch (Exception e) {
            return Result.error(401, "Token无效或已过期");
        }
    }

    /**
     * 修改个人信息
     * PUT /api/user/update
     */
    @PutMapping("/update")
    public Result<?> updateUserInfo(
            @RequestHeader("Authorization") String authorization,
            @RequestBody Map<String, String> params) {
        try {
            String token = authorization.replace("Bearer ", "");
            Integer userId = jwtUtil.getUserIdFromToken(token);

            String email = params.get("email");
            String phone = params.get("phone");

            userService.updateUserInfo(userId, email, phone);

            return Result.success("修改成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    /**
     * 修改密码
     * PUT /api/user/password
     */
    @PutMapping("/password")
    public Result<?> updatePassword(
            @RequestHeader("Authorization") String authorization,
            @RequestBody Map<String, String> params) {
        try {
            String token = authorization.replace("Bearer ", "");
            Integer userId = jwtUtil.getUserIdFromToken(token);

            String oldPassword = params.get("oldPassword");
            String newPassword = params.get("newPassword");

            userService.updatePassword(userId, oldPassword, newPassword);

            return Result.success("密码修改成功", null);
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping("/avatar")
    public Result<?> uploadAvatar(
            @RequestHeader("Authorization") String authorization,
            @RequestParam("file") MultipartFile file) {
        try {
            String token = authorization.replace("Bearer ", "");
            Integer userId = jwtUtil.getUserIdFromToken(token);

            // 1. 验证文件类型
            String originalFilename = file.getOriginalFilename();
            if (originalFilename == null || (!originalFilename.endsWith(".jpg") &&
                    !originalFilename.endsWith(".png"))) {
                return Result.error("只支持 jpg/png 格式");
            }

            // 2. 验证文件大小（2MB）
            if (file.getSize() > 2 * 1024 * 1024) {
                return Result.error("文件大小不能超过2MB");
            }

            // 3. 生成新文件名
            String newFilename = userId + "_" + System.currentTimeMillis() +
                    originalFilename.substring(originalFilename.lastIndexOf("."));

            // 4. 保存文件
            String uploadPath = System.getProperty("user.dir") + "/uploads/avatars/";
            java.io.File dir = new java.io.File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            file.transferTo(new java.io.File(uploadPath + newFilename));

            // 5. 更新用户头像路径
            String avatarPath = "/images/avatar/" + newFilename;
            userService.updateAvatar(userId, avatarPath);

            Map<String, Object> data = new HashMap<>();
            data.put("avatar", avatarPath);

            return Result.success("上传成功", data);
        } catch (Exception e) {
            return Result.error("上传失败: " + e.getMessage());
        }
    }
}
