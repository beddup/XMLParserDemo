//
//  ViewController.m
//  XMLParseDemo
//
//  Created by Amay on 10/28/15.
//  Copyright © 2015 Beddup. All rights reserved.
//

#import "XMLParserViewController.h"
#import "CD.h"
#import "CDCell.h"

NSString *const XMLURL = @"http://www.w3school.com.cn/example/xmle/cd_catalog.xml";

@interface XMLParserViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic)NSArray* parserResult;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XMLParserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self.tableView registerNib:[UINib nibWithNibName:@"CDCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cd cell"];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)configureNavigationBar{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Start Parse" style:UIBarButtonItemStylePlain target:self action:@selector(startParse:)];
    self.navigationItem.rightBarButtonItem = barButton;
}

-(void)startParse:(id)sender{
//    [self parseXMLFile];
    [self fetchXMLData];
}

-(void)fetchXMLData
{
    NSURLSession *session =[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:XMLURL];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSXMLParser *parse = [[NSXMLParser alloc] initWithData:data];
        parse.delegate = self;
        [parse parse];
    }];
    [dataTask resume];
}
-(void)parseXMLFile
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"view-source_www.w3school.com.cn_example_xmle_cd_catalog" ofType:@"xml"];
    NSData* xmlData = [NSData dataWithContentsOfFile:path];
    NSXMLParser *parse = [[NSXMLParser alloc] initWithData:xmlData];
    parse.delegate = self;
    [parse parse];
}
#pragma mark - Table View DataSource And Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.parserResult.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cd cell"];
    CD* cd = self.parserResult[indexPath.row];
    cell.cd = cd;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark - ParseDelegate
static NSMutableArray* elementObjectStack = nil;
static NSMutableString* currentString =nil;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"started");
    elementObjectStack = [@[] mutableCopy];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"end");
    self.parserResult = [elementObjectStack lastObject];
    [self.tableView reloadData];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentString) {
        currentString = [string mutableCopy];
    }else{
        [currentString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{

    const char* elementNameCString = [elementName cStringUsingEncoding:NSUTF8StringEncoding];

    Class elementClass = objc_getClass(elementNameCString);
    id elementObject = nil;

    if (elementClass)
    {
        elementObject = [[elementClass alloc] init];
    }else
    {
        elementObject = [@[] mutableCopy];
    }

    [elementObjectStack addObject:elementObject];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    if (elementObjectStack.count == 1) {
        return;
    }
    id elementObject = nil;
    NSString* parsedString = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (parsedString.length) {
        elementObject = parsedString;
    }else{
        elementObject = [elementObjectStack lastObject];
    }
//    [tagsStack removeLastObject];
    [elementObjectStack removeLastObject];

    id lastElement = [elementObjectStack lastObject];
    if ([lastElement isKindOfClass:[NSMutableArray class]])
    {
        // if it is a array
        [((NSMutableArray* )lastElement) addObject:elementObject];
    }
    else
    {
        // if it is other class
        NSString *selString = [NSString stringWithFormat:@"set%@:",[elementName capitalizedString]];
        const char* selCString = [selString cStringUsingEncoding:NSUTF8StringEncoding];
        SEL selector = sel_registerName(selCString);
        [lastElement performSelector:selector withObject:elementObject];
    }

    currentString = nil;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
