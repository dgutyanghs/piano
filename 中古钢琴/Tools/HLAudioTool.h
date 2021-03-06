

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HLAudioTool : NSObject
/**
 *  播放音效
 *
 *  @param filename 音效文件名
 */
+ (void)playSound:(NSString *)filename;

/**
 *  销毁音效
 *
 *  @param filename 音效文件名
 */
+ (void)disposeSound:(NSString *)filename;

/**
 *  播放音乐
 *
 *  @param filename 音乐文件名
 */
+ (AVAudioPlayer *)playMusic:(NSString *)filename;

/**
 *  暂停音乐
 *
 *  @param filename 音乐文件名
 */
+ (void)pauseMusic:(NSString *)filename;

/**
 *  停止音乐
 *
 *  @param filename 音乐文件名
 */
+ (void)stopMusic:(NSString *)filename;

/**
 *  返回当前正在播放的音乐播放器
 */
+ (AVAudioPlayer *)currentPlayingAudioPlayer;


/**
 * 播放计数器声音，因为它需要调节音量，只能使用AVAudioPlayer类了
 *
 */
+(AVAudioPlayer *)playCounterSound:(NSString *)filename;



/**
 *  停止计数器声音
 */
+ (void)stopCounterSound:(AVAudioPlayer *)audioPlayer;


@end
