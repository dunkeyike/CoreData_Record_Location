//
//  RootViewController.m
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 23..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import "RootViewController.h"
#import "Event.h"
#import "DetailViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize managedObjContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// 역지오 좌표->주소 변환을 위한 객체 추기화
	geocoder = [[CLGeocoder alloc] init];

	// 뷰 타이틀 설정
	self.title = @"Locations";
	
	// 네비게이션바에 들어가는 버튼 설정
	// 왼쪽은 편집 버튼
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	// 오른쪽은 추가 버튼
	// 추가 버튼을 눌렀을때의 호출될 메소드 설정
	btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
	// 초기 설정은 무효화 시킨다
	// 위치정보를 얻게 되면 유효화 시킴
	btnAdd.enabled = NO;
	self.navigationItem.rightBarButtonItem = btnAdd;
	
	// 열심히 위치 취득 시작!
	[[self locationManager] startUpdatingLocation];
	

	// 코어데이터에 데이터를 가져오기위한 준비
	NSFetchRequest *request = [NSFetchRequest new];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjContext];
	[request setEntity:entity];
	// 가져올 객체를 정렬해서 가져오게함
	NSSortDescriptor *sortDate = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDate, nil];
	[request setSortDescriptors:sortArray];
	
	NSError *error = nil;
	
	// 위에서 설정한대로 코어데이터안에서 데이터를 가져오게함
	// SQL에서 쿼리를 날리는것과 비슷
	NSMutableArray *arrResults = [[managedObjContext executeFetchRequest:request error:&error] mutableCopy];
	if (arrResults == nil) {
		// error!!
	}
	
	// 가져온 데이터를 테이블뷰에서 사용할 객체에 대입
	eventsArray = arrResults;
	
}

#pragma mark - Table view data source
// 테이블뷰 섹션갯수 반환
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 각섹션의 셀의 갯수 반환
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventsArray count];
}

// 각셀의 높이 반환
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// 날짜 표시방식 설정
	// 주소이름이 나오게 함으로 사용하지 않음
//	static NSDateFormatter *dateFormatter = nil;
//	if (dateFormatter == nil) {
//		dateFormatter = [[NSDateFormatter alloc] init];
//		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//	}

	// 숫자 표시방식 설정
	// 소수점 3자리까지 나오도록 설정
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
	
	// 테이블뷰 셀 설정
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	// 다음뷰로 넘어 갈꺼니까 꺽쇠 화살표 표시
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	// 셀에 표시한 데이터를 가지고 있는 객체
	Event *event = (Event *)[eventsArray objectAtIndex:indexPath.row];
	
	// 셀에 내용을 표시함
	// 주소이름
	cell.textLabel.text = [event locationname];
	cell.textLabel.numberOfLines = 2;
	// 위도 경도 표시
	NSString *str = [NSString stringWithFormat:@"위도:%@  경도:%@", [numberFormatter stringFromNumber:[event latitude]], [numberFormatter stringFromNumber:[event longitude]]];
	cell.detailTextLabel.text = str;
    
    return cell;
}
#pragma mark - UITableView Delegate
// 셀을 선택하면 상세화면(맵뷰)로 이동하기
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DetailViewController *detailCon = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
	
	// 선탣한 셀의 데이터를 가져오고
	Event *event = (Event *)[eventsArray objectAtIndex:indexPath.row];
	
	// 거기서 좌표정보만 빼내서
	CLLocationCoordinate2D selectLocation = CLLocationCoordinate2DMake([[event latitude] doubleValue], [[event longitude] doubleValue]);
	
	// 상세화면에 넘김
	detailCon.location = selectLocation;
	// 주소이름도 함께 넘김
	detailCon.addressName = [event locationname];
	
	// 네비게이션 이동
	[self.navigationController pushViewController:detailCon animated:YES];
}


// 테이블뷰의 편집모드에서의 동작 설정
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// 편집모드가 삭제일경우
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 데이타 삭제할 객체 생성
		NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
		[managedObjContext deleteObject:eventToDelete];
		
		// 테이블뷰 갱신
		[eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		// 코어 데이터상에 반영
		NSError *error = nil;
		if (![managedObjContext save:&error]) {
			// error
		}
    }
	// 편집모드가 추가일때
	// 여기서는 사용하지 않음
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - CLLocation
// 코어 로케이션의 초기 설정
- (CLLocationManager *) locationManager {
	if (locationManager != nil) {
		return locationManager;
	}
	
	// 객체 초기화하고
	locationManager = [[CLLocationManager alloc] init];
	// 정확도 설정후
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	// 딜리게이트를 지금의 뷰컨트롤러에 맡긴다
	locationManager.delegate = self;
	
	// 객체 반환
	return locationManager;
}

// 코어 로케이션의 딜리게이트
#pragma mark - Core Location manager delegate
// 위치정보가 업데이트 될때마다 불림
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	
	// 아이폰 설정에서 위치정보 승인을 했는지 판단
	if([CLLocationManager locationServicesEnabled] == YES){
		// 위치정보를 취득 할수 있으니 추가 버튼을 유효화
		btnAdd.enabled = YES;
	}
	
}
// 위치정보 취득이 실패 했을때
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	// 추가 버튼을 무효화
	btnAdd.enabled = NO;
}

#pragma mark - BarButton Action Methods
// 추가 버튼을 눌렸을경우의 이벤트 처리
- (void) addEvent {
	
	// 코어 로케이션에서 얻은 위도, 경도 값 취득
	CLLocation *location = [locationManager location];
	if (!location) {
		return;
	}
    
	// 취득한 위치정보(좌표) 로 해당 지역의 주소를 얻어온다
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
		// 각각의 위치정보의 주소정보를 가지는 객체 CLPlacemark에 주소정보 대입
		placemark = [placemarks lastObject];
		// 주소정보로 문자열을 만듬
		NSString *locationName = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
						 placemark.country, placemark.administrativeArea, placemark.locality, placemark.thoroughfare, placemark.subThoroughfare];
		
		// 코어데이터에 추가할 객체를 managedObjContext에 알려줌
		Event *event = (Event*)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjContext];
		
		// 추가할 객체에 데이터를 넣어줌
		CLLocationCoordinate2D coordinate = [location coordinate];
		[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
		[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
		[event setCreationDate:[NSDate date]];
		[event setLocationname:locationName];
		
		// 코어데이터에 저장!
		NSError *saveError = nil;
		if (![managedObjContext save:&saveError]) {
			// 여기서 에러처리
		}
		
		// 저장이 잘되었으면 테이블뷰에서 사용할 배열객체에 0번째에 넣어줌
		[eventsArray insertObject:event atIndex:0];
		// 테이블 넣어줄 위치 (0,0)를 설정
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		// 테이블뷰에 객데이터를 넣으면서 애니메이션을 적용
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		// 테이블뷰를 가장 위로 올려줌
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } ];
}
@end
