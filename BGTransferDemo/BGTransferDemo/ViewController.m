//
//  ViewController.m
//  BGTransferDemo
//
//  Created by Gabriel Theodoropoulos on 25/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ViewController.h"
#import "FileDownloadInfo.h"
#import "AppDelegate.h"


// Define some constants regarding the tag values of the prototype cell's subviews.
#define CellLabelTagValue               10
#define CellStartPauseButtonTagValue    20
#define CellStopButtonTagValue          30
#define CellProgressBarTagValue         40
#define CellLabelReadyTagValue          50


@interface ViewController ()

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;

@property (nonatomic, strong) NSURL *docDirectoryURL;


-(void)initializeFileDownloadDataArray;
-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier;

@end



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self initializeFileDownloadDataArray];
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.docDirectoryURL = [URLs objectAtIndex:0];
    
    
    // Make self the delegate and datasource of the table view.
    self.tblFiles.delegate = self;
    self.tblFiles.dataSource = self;
    
    // Disable scrolling in table view.
    self.tblFiles.scrollEnabled = NO;
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.BGTransferDemo"];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private method implementation

-(void)initializeFileDownloadDataArray{
    self.arrFileDownloadData = [[NSMutableArray alloc] init];
    
    [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"iOS Programming Guide" andDownloadSource:@"https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf"]];
    [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"Human Interface Guidelines" andDownloadSource:@"https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/MobileHIG.pdf"]];
    [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"Networking Overview" andDownloadSource:@"https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/NetworkingOverview.pdf"]];
    [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"AV Foundation" andDownloadSource:@"https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/AVFoundationPG.pdf"]];
    [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"iPhone User Guide" andDownloadSource:@"http://manuals.info.apple.com/MANUALS/1000/MA1565/en_US/iphone_user_guide.pdf"]];
}


-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier{
    int index = 0;
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}


#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrFileDownloadData.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idCell"];
    }
    
    // Get the respective FileDownloadInfo object from the arrFileDownloadData array.
    FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:indexPath.row];
    
    // Get all cell's subviews.
    UILabel *displayedTitle = (UILabel *)[cell viewWithTag:10];
    UIButton *startPauseButton = (UIButton *)[cell viewWithTag:CellStartPauseButtonTagValue];
    UIButton *stopButton = (UIButton *)[cell viewWithTag:CellStopButtonTagValue];
    UIProgressView *progressView = (UIProgressView *)[cell viewWithTag:CellProgressBarTagValue];
    UILabel *readyLabel = (UILabel *)[cell viewWithTag:CellLabelReadyTagValue];
    
    NSString *startPauseButtonImageName;
    
    // Set the file title.
    displayedTitle.text = fdi.fileTitle;
    
    // Depending on whether the current file is being downloaded or not, specify the status
    // of the progress bar and the couple of buttons on the cell.
    if (!fdi.isDownloading) {
        // Hide the progress view and disable the stop button.
        progressView.hidden = YES;
        stopButton.enabled = NO;
        
        // Set a flag value depending on the downloadComplete property of the fdi object.
        // Using it will be shown either the start and stop buttons, or the Ready label.
        BOOL hideControls = (fdi.downloadComplete) ? YES : NO;
        startPauseButton.hidden = hideControls;
        stopButton.hidden = hideControls;
        readyLabel.hidden = !hideControls;
        
        startPauseButtonImageName = @"play-25";
    }
    else{
        // Show the progress view and update its progress, change the image of the start button so it shows
        // a pause icon, and enable the stop button.
        progressView.hidden = NO;
        progressView.progress = fdi.downloadProgress;
        
        stopButton.enabled = YES;
        
        startPauseButtonImageName = @"pause-25";
    }
    
    // Set the appropriate image to the start button.
    [startPauseButton setImage:[UIImage imageNamed:startPauseButtonImageName] forState:UIControlStateNormal];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


#pragma mark - IBAction method implementation

- (IBAction)startOrPauseDownloadingSingleFile:(id)sender {
    // Check if the parent view of the sender button is a table view cell.
    if ([[[[sender superview] superview] superview] isKindOfClass:[UITableViewCell class]]) {
        // Get the container cell.
        UITableViewCell *containerCell = (UITableViewCell *)[[[sender superview] superview] superview];
        
        // Get the row (index) of the cell. We'll keep the index path as well, we'll need it later.
        NSIndexPath *cellIndexPath = [self.tblFiles indexPathForCell:containerCell];
        int cellIndex = cellIndexPath.row;
        
        // Get the FileDownloadInfo object being at the cellIndex position of the array.
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:cellIndex];
        
        // The isDownloading property of the fdi object defines whether a downloading should be started
        // or be stopped.
        if (!fdi.isDownloading) {
            // This is the case where a download task should be started.
            
            // Create a new task, but check whether it should be created using a URL or resume data.
            if (fdi.taskIdentifier == -1) {
                // If the taskIdentifier property of the fdi object has value -1, then create a new task
                // providing the appropriate URL as the download source.
                fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
                
                // Keep the new task identifier.
                fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                
                // Start the task.
                [fdi.downloadTask resume];
            }
            else{
            	// Create a new download task, which will use the stored resume data.
                fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
                [fdi.downloadTask resume];
                
                // Keep the new download task identifier.
                fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
            }
        }
        else{
            // Pause the task by canceling it and storing the resume data.
            [fdi.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                if (resumeData != nil) {
                    fdi.taskResumeData = [[NSData alloc] initWithData:resumeData];
                }
            }];
        }
        
        // Change the isDownloading property value.
        fdi.isDownloading = !fdi.isDownloading;
        
        // Reload the table view.
        [self.tblFiles reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (IBAction)stopDownloading:(id)sender {
    if ([[[[sender superview] superview] superview] isKindOfClass:[UITableViewCell class]]) {
        // Get the container cell.
        UITableViewCell *containerCell = (UITableViewCell *)[[[sender superview] superview] superview];
        
        // Get the row (index) of the cell. We'll keep the index path as well, we'll need it later.
        NSIndexPath *cellIndexPath = [self.tblFiles indexPathForCell:containerCell];
        int cellIndex = cellIndexPath.row;
        
        // Get the FileDownloadInfo object being at the cellIndex position of the array.
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:cellIndex];
        
        // Cancel the task.
        [fdi.downloadTask cancel];
        
        // Change all related properties.
        fdi.isDownloading = NO;
        fdi.taskIdentifier = -1;
        fdi.downloadProgress = 0.0;
        
        // Reload the table view.
        [self.tblFiles reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (IBAction)startAllDownloads:(id)sender {
    // Access all FileDownloadInfo objects using a loop.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        // Check if a file is already being downloaded or not.
        if (!fdi.isDownloading) {
            // Check if should create a new download task using a URL, or using resume data.
            if (fdi.taskIdentifier == -1) {
                fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
            }
            else{
                fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
            }
            
            // Keep the new taskIdentifier.
            fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
            
            // Start the download.
            [fdi.downloadTask resume];
            
            // Indicate for each file that is being downloaded.
            fdi.isDownloading = YES;
        }
    }
    
    // Reload the table view.
    [self.tblFiles reloadData];
}


- (IBAction)stopAllDownloads:(id)sender {
    // Access all FileDownloadInfo objects using a loop.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        // Check if a file is being currently downloading.
        if (fdi.isDownloading) {
            // Cancel the task.
            [fdi.downloadTask cancel];
            
            // Change all related properties.
            fdi.isDownloading = NO;
            fdi.taskIdentifier = -1;
            fdi.downloadProgress = 0.0;
            fdi.downloadTask = nil;
        }
    }
    
    // Reload the table view.
    [self.tblFiles reloadData];
}


- (IBAction)initializeAll:(id)sender {
    // Access all FileDownloadInfo objects using a loop and give all properties their initial values.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        if (fdi.isDownloading) {
            [fdi.downloadTask cancel];
        }
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = NO;
        fdi.taskIdentifier = -1;
        fdi.downloadProgress = 0.0;
        fdi.downloadTask = nil;
    }
    
    // Reload the table view.
    [self.tblFiles reloadData];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Get all files in documents directory.
    NSArray *allFiles = [fileManager contentsOfDirectoryAtURL:self.docDirectoryURL
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (int i=0; i<[allFiles count]; i++) {
        [fileManager removeItemAtURL:[allFiles objectAtIndex:i] error:nil];
    }
}


#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:destinationFilename];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    
    if (success) {
        // Change the flag values of the respective FileDownloadInfo object.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = YES;
        
        // Set the initial value to the taskIdentifier property of the fdi object,
        // so when the start button gets tapped again to start over the file download.
        fdi.taskIdentifier = -1;
        
        // In case there is any resume data stored in the fdi object, just make it nil.
        fdi.taskResumeData = nil;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Reload the respective table view row using the main thread.
            [self.tblFiles reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        
    }
    else{
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
    }
    else{
        NSLog(@"Download finished successfully.");
    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        // Locate the FileDownloadInfo object among all based on the taskIdentifier property of the task.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
      
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Calculate the progress.
            fdi.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
              
            // Get the progress view of the appropriate cell and update its progress.
            UITableViewCell *cell = [self.tblFiles cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            UIProgressView *progressView = (UIProgressView *)[cell viewWithTag:CellProgressBarTagValue];
            progressView.progress = fdi.downloadProgress;
        }];
    }
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
}

@end
