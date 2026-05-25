export interface CheckInFormDto {
  rightCount: number
  answeredCount: number
  timeUsed: number
}

export interface PostInfoDto {
  id: number //
  postText: string // 打卡文案
  rightCount: number // 正确个数
  answeredCount: number // 答题个数
  timeUsed: number // 用时
  createTime: string // 打卡时间
  likeCount: number // 点赞个数
  nickname: string // 昵称
  avatarUrl: string // 头像地址
  isLike: boolean // 是否点赞
}

@Observed
export class PostInfo {

  id: number //
  postText: string // 打卡文案
  rightCount: number // 正确个数
  answeredCount: number // 答题个数
  timeUsed: number // 用时
  createTime: string // 打卡时间
  likeCount: number // 点赞个数
  nickname: string // 昵称
  avatarUrl: string // 头像地址
  isLike: boolean // 是否点赞

  constructor(post: PostInfoDto) {
    this.id = post.id;
    this.postText = post.postText;
    this.rightCount = post.rightCount;
    this.answeredCount = post.answeredCount;
    this.timeUsed = post.timeUsed;
    this.createTime = post.createTime;
    this.likeCount = post.likeCount;
    this.nickname = post.nickname;
    this.avatarUrl = post.avatarUrl;
    this.isLike = post.isLike;
  }


}