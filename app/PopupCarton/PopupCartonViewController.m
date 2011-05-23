//
//  PopupCartonViewController.m
//  PopupCarton
//
//  Created by Kaname Noto on 11/05/23.
//  Copyright 2011 Irimasu Densan Planning. All rights reserved.
//

#import "PopupCartonViewController.h"

@implementation PopupCartonViewController

@synthesize packageView=_packageView;

#define PACKAGE_POPUP_LENGTH 500.0f

- (IBAction) firedStart:(id)sender
{
    // 箱レイヤを削除
    [packageLayer_ removeFromSuperlayer];
    [packageLayer_ release];
    packageLayer_ = nil;
    
    CGFloat scale = [[UIScreen mainScreen] respondsToSelector:NSSelectorFromString(@"scale")] ? [UIScreen mainScreen].scale : 1.0f;
    // スケールを判別
	NSString* packageImageName = ( scale > 1.0f ) ? @"Package@2x.png" : @"Package.png"; // 画像解像度によって読み込む画像切り分け
	NSString* packageSourcePath = [[NSBundle mainBundle] pathForResource:[packageImageName stringByDeletingPathExtension] ofType:[packageImageName pathExtension] ];
        // 絶対パスを取得する
    
	NSData* packageData = [[NSData alloc] initWithContentsOfFile:packageSourcePath];
        // データを取得する
	UIImage* packageImage = [[UIImage alloc] initWithData:packageData];
        // イメージを取得する
    
	CGSize layersize = self.packageView.frame.size; // CALayer のインスタンスを挿入するview のサイズをもとにする
	packageLayer_ = [[CALayer alloc] init]; // CALayer の初期化
	packageLayer_.bounds = CGRectMake(0.0f,0.0f,layersize.width ,layersize.height ); // 画像サイズを引き渡す
	packageLayer_.position = CGPointMake(layersize.width * 0.5f , layersize.height * 0.5f ); // 挿入先view の中心に配置
	packageLayer_.contents = (id)[packageImage CGImage]; // イメージを設定
    
    // 利用を終えた画像リソースを削除
	[packageData release];
	[packageImage release];
    
	[self.packageView.layer addSublayer:packageLayer_]; // CALayer のインスタンスをサブレイヤーに配置
    
    // アニメーションを登録
    CABasicAnimation* popupAnimation = [[CABasicAnimation alloc] init];
    popupAnimation.keyPath = @"position.y"; // 座標を移動する
    popupAnimation.fromValue = [NSNumber numberWithFloat:packageLayer_.position.y + PACKAGE_POPUP_LENGTH]; // 下から上へ移動
    popupAnimation.toValue = [NSNumber numberWithFloat:packageLayer_.position.y]; // CALayer の位置に移動
    popupAnimation.duration = 0.8f; // アニメーション時間 [秒].[ミリ秒]
    popupAnimation.repeatCount = 1.0f; // 繰り返し回数
    
    [packageLayer_ addAnimation:popupAnimation forKey:@"popupPackageAnimation"];
        // キー名@"popupPackageAnimation" で登録、途中で中断したい場合はキー名を指定して削除する
    
    // アニメーション終了後のCALayer のインスタンスの位置は？
    // アニメーション終了後はCALayer のインスタンスのプロパティが示す位置に戻る
    // A-B地点 へ移動し、B地点に移動するアニメーションを実現するためには、CALayer の位置を変更しておく必要がある
    
    
    // アニメーション終了後のレイヤーへの値値反映はこのタイミングで記述
    [popupAnimation release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [packageLayer_ release];
    packageLayer_ = nil;
    
    self.packageView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [packageLayer_ release];
    [_packageView release];
    
    [super dealloc];
}

@end
