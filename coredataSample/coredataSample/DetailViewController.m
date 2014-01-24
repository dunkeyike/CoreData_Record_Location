//
//  DetailViewController.m
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 24..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomAnnotation.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize location;
@synthesize mapView;
@synthesize addressName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
	// 맵뷰의 타입설정
	self.mapView.mapType = MKMapTypeStandard;
	// 딜리게이트 위임
	self.mapView.delegate = self;
	// 지역 설정 객체
	MKCoordinateRegion	region;
	// 지도의 표시 비율 객체
	MKCoordinateSpan	span;
	// 숫자가 작아지면 작아 질수록 정확해짐
	span.latitudeDelta = 0.005;
	span.longitudeDelta = 0.005;
	
	// 지역 정보에 지도 표시 비율과 위치 정보를 설정
	region.span = span;
	region.center = location;
	
	// 맵뷰에 표시할 지역 설정
	[self.mapView setRegion:region animated:YES];
	

	// 지도 주석 객체(핀)	
	MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];

	// 테이블뷰에서 받아온 주소를 공백으로 나눠서 배열에 넣어두고
	NSArray *arrStr = [self.addressName componentsSeparatedByString:@" "];
	// 초기에 표시할 주소의 문자열
	NSMutableString *strTitle = [[NSMutableString alloc] init];
	// 번지앞 주소 (동이름등)
	[strTitle appendString:[arrStr objectAtIndex:[arrStr count] -2]];
	// 공백하나 넣어주고
	[strTitle appendString:@" "];
	// 주소의 번지를 넣어주고
	[strTitle appendString:[arrStr lastObject]];
	
	// 핀이 꼽힐 좌표를 넣어주고
	pin.coordinate = location;
	// 핀에 표시될 문자열 넣어주고
	pin.title = strTitle;
	// 맵뷰에 핀 꽇아주면 끝!
	[self.mapView addAnnotation:pin];
}

#pragma mark - MKMapDelegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	
	// 핀이표시될 좌표정보를 얻어서
    CGRect visibleRect = [self.mapView annotationVisibleRect];
	// 핀들객수 만큼 돌려주면서
    for (MKAnnotationView *view in views) {
		// 핀의 좌표값을
        CGRect endFrame = view.frame;
		// 초기 조표값으로 설정후
        CGRect startFrame = endFrame;
		// y값을 화면 밖으로 빼낸후
        startFrame.origin.y = visibleRect.origin.y - startFrame.size.height-100;
		// 다시 초기 좌표값으로 설정
        view.frame = startFrame;
		// 그리고 원래 초기좌표로 에니메이션 시켜줌
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:0.5];
        view.frame = endFrame;
        [UIView commitAnimations];
		// 그럼 핀이 위에서 딱 떨어지는것처럼 보이겠죠?
	}
	// 각각의 핀 악세사리에 버튼을 하나 똬악!!!
	[views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        ((MKAnnotationView*)obj).rightCalloutAccessoryView
		= [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }];
}

// 핀외의 곳을 선택하면 (핀 선택을 취소하면)
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	// 원래대로 악세사리를 버튼 하나만으로 설정
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

// 핀을 선택했을때
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	
	// 자세한 주소정보를 보여주기 위해 라벨을 하나 만들어주고
    UILabel* sample = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 32.f)];
	// 배경색은 투명
    sample.backgroundColor = [UIColor clearColor];
	// 폰트는 헤베티카에 12사이즈
    sample.font = [UIFont fontWithName:@"Helvetica" size: 12];
	// 내용은 테이블뷰에서 받아온 풀 주소
    sample.text = self.addressName;
	// 글씨색은 검은색
    sample.textColor = [UIColor blackColor];
	// 원래 있던 버튼을 없애고
    view.rightCalloutAccessoryView = nil;
	// 방금 만든 풀 주소를 보여줄 라벨을 넣어줌
    view.rightCalloutAccessoryView = sample;
}
@end
