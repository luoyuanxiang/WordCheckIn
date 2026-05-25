import { AxiosResponse } from "@ohos/axios";
import { CheckInFormDto, PostInfo, PostInfoDto } from "../types/CheckIn";
import { LoginFormDto } from "../types/LoginFormDto";
import { Result, ResultPage } from "../types/Result";
import { UserInfo } from "../types/UserInfo";
import { instance } from "../utils/Axios";

/**
 * 发送验证码
 * @param phone 手机号
 */
export function sendCode(phone: string): Promise<AxiosResponse<Result<string>>> {
  return instance.get('/word/user/code', { params: { phone } })
}

/**
 * 登录
 * @param data 登录数据
 */
export function login(data: LoginFormDto): Promise<AxiosResponse<Result<string>>> {
  return instance.post('/word/user/login', data)
}

/**
 * 签到
 * @param data 签到数据
 */
export function checkIn(data: CheckInFormDto): Promise<AxiosResponse<Result<string>>> {
  return instance.post('/word/post/create', data)
}

/**
 * 获取签到信息列表
 */
export function getCheckInInfoList(page: number, size: number = 10): Promise<AxiosResponse<Result<ResultPage<PostInfo>>>> {
  return instance.get('/word/post/getAll', { params: { page, size } })
}

/**
 * 获取签到信息列表-我
 */
export function getMyCheckInInfoList(page: number, size: number = 10): Promise<AxiosResponse<Result<ResultPage<PostInfoDto>>>> {
  return instance.get('/word/post/getMine', { params: { page, size } })
}

/**
 * 获取用户信息
 */
export function getUserInfo(): Promise<AxiosResponse<Result<UserInfo>>> {
  return instance.get('/word/user/info')
}

/**
 * 点赞
 * @param postId 帖子id
 */
export function createLike(postId: string) {
  return instance.get('/word/like/create', { params: { postId } })
}

/**
 * 取消点赞
 * @param postId 帖子id
 */
export function deleteLike(postId: string) {
  return instance.get('/word/like/cancel', { params: { postId } })
}