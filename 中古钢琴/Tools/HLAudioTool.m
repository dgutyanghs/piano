//  MJAudioTool.m
//  01-音频播放
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HLAudioTool.h"

@implementation HLAudioTool

/**
 *  存放所有的音频ID
 *  字典: filename作为key, soundID作为value
 */
static NSMutableDictionary *_soundIDDict;

/**
 *  存放所有的音乐播放器
 *  字典: filename作为key, audioPlayer作为value
 */
static NSMutableDictionary *_audioPlayerDict;

/**
 *  初始化
 */
+ (void)initialize
{
    _soundIDDict = [NSMutableDictionary dictionary];
    _audioPlayerDict = [NSMutableDictionary dictionary];
    
    // 设置音频会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 设置后台播放允许AVAudioSessionCategoryPlayback
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}

/**
 *  播放音效
 *
 *  @param filename 音效文件名
 */
+ (void)playSound:(NSString *)filename
{
    if (!filename) return;
    
    // 1.从字典中取出soundID
    SystemSoundID soundID = [_soundIDDict[filename] unsignedIntValue];
    if (!soundID) { // 创建
        // 加载音效文件
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        if (!url) return;
        
        // 创建音效ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        
        // 放入字典
        _soundIDDict[filename] = @(soundID);
    }
    
    // 2.播放
    AudioServicesPlaySystemSound(soundID);
}

/**
 *  销毁音效
 *
 *  @param filename 音效文件名
 */
+ (void)disposeSound:(NSString *)filename
{
    if (!filename) return;
    
    SystemSoundID soundID = [_soundIDDict[filename] unsignedIntValue];
    if (soundID) {
        // 销毁音效ID
        AudioServicesDisposeSystemSoundID(soundID);
        
        // 从字典中移除
        [_soundIDDict removeObjectForKey:filename];
    }
}


/**
 *  播放音乐
 *
 *  @param filename 音乐文件名
 */
//+ (AVAudioPlayer *)playMusic:(NSString *)filename
//{
//    if (!filename) return nil;
//    // 1.从字典中取出audioPlayer
//    AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
//    if (!audioPlayer) { // 创建
//        // 加载音乐文件
//        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *filepath = [caches stringByAppendingPathComponent:filename];
//        
//        NSURL *url = [NSURL fileURLWithPath:filepath];
//        if (!url) return nil;
//        
//        // 创建audioPlayer
//        NSError *error;
//        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        if (audioPlayer == nil) {
//            NSLog(@"audioplayer create error %@",error.description);
////            [MBProgressHUD showError:[NSString stringWithFormat:@"%@错误", filename]];
//        } else {
//            // 放入字典
//            _audioPlayerDict[filename] = audioPlayer;
//        }
//    }
//    
//    return audioPlayer;
//}

/**
 *  播放音乐
 *
 *  @param filename 音乐文件名
 */
+ (AVAudioPlayer *)playMusic:(NSString *)filename
{
    if (!filename) return nil;
    
    // 1.从字典中取出audioPlayer
    AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
    if (!audioPlayer) { // 创建
        // 加载音乐文件
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        if (!url) return nil;
        
        // 创建audioPlayer
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        // 放入字典
        _audioPlayerDict[filename] = audioPlayer;
    }
    [audioPlayer play];
    
    return audioPlayer;
}




/**
 *  暂停音乐
 *
 *  @param filename 音乐文件名
 */
+ (void)pauseMusic:(NSString *)filename
{
    if (!filename) return;
    
    // 1.从字典中取出audioPlayer
    AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
    
    // 2.暂停
    if (audioPlayer.isPlaying) {
        [audioPlayer pause];
    }
}

/**
 *  停止音乐
 *
 *  @param filename 音乐文件名
 */
//+ (void)stopMusic:(NSString *)filePath
//{
//    if (!filename) return;
//    
//    // 1.从字典中取出audioPlayer
//    AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
//    
//    // 2.暂停
//    if (audioPlayer.isPlaying) {
//        [audioPlayer stop];
//        
//        // 直接销毁
//        [_audioPlayerDict removeObjectForKey:filename];
//    }
//}
+ (void)stopMusic:(NSString *)filename
{
    if (!filename) return;
    
    // 1.从字典中取出audioPlayer
    AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
    
    // 2.暂停
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
        
        // 直接销毁
        [_audioPlayerDict removeObjectForKey:filename];
    }
}

/**
 *  返回当前正在播放的音乐播放器
 */
+ (AVAudioPlayer *)currentPlayingAudioPlayer
{
    for (NSString *filename in _audioPlayerDict) {
        AVAudioPlayer *audioPlayer = _audioPlayerDict[filename];
        
        if (audioPlayer.isPlaying) {
            return audioPlayer;
        }
    }
    
    return nil;
}



/**
 * 播放计数器声音，因为它需要调节音量，只能使用AVAudioPlayer类了
 *
 */
+(AVAudioPlayer *)playCounterSound:(NSString *)filename
{
    if (!filename) return nil;
    
    // 加载音乐文件
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    
    if (!url) return nil;
    
    // 创建audioPlayer
    AVAudioPlayer * audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    // 缓冲
    [audioPlayer prepareToPlay];
    
    return audioPlayer;
}



/**
 *  停止计数器声音
 */
+ (void)stopCounterSound:(AVAudioPlayer *)audioPlayer
{
    // 2.暂停
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
    }
}
@end
