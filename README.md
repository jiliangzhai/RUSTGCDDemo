
## GCD

### 关于这个DEMO

主要是GCD几个基本功能的演示，采用的方法是利用图片的加载演示GCD不同调用方法的不同效果。包括：串行/并发队列的调用，任务的分组管理，任务中的顺序控制，线程同步以及NSCondition的使用。

### 演示代码

#### 串行队列同步加载和异步加载

这里采用图片加载来进行演示：

	- (void)loadImage{
    
    	for (int i=0; i<row*column; i++) {
        
        	NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        	[imageURL addObject:urlStr];
    	}
    
    	dispatch_queue_t serialQueue = dispatch_queue_create("rust_33SerialQueue", DISPATCH_QUEUE_SERIAL);
    
    	for (int i=0;i<row*column;i++) {
        
        	/* dispatch_sync(serialQueue, ^{
            
            	[self loadImageAtIndex:i];
            
        	}); */
        
        	dispatch_async(serialQueue, ^{
            
            	[self loadImageAtIndex:i];
            
        	}); 
        
    	}
    
	}

	- (void)loadImageAtIndex:(NSInteger)index
	{
    	NSString *str = [imageURL objectAtIndex:index];
    
		NSData *data = [NSData dataWithContentsOfURL:		[NSURL URLWithString:str]];
    	UIImage *image = [UIImage imageWithData:data];
    
    	[self updateImage:image atIndex:index];
    
	}

	- (void)updateImage:(UIImage *)image atIndex:	(NSInteger)index
	{
    	UIImageView *imageView = [imageViews 	objectAtIndex:index];
    
    	dispatch_async(dispatch_get_main_queue(), ^{
        
        	imageView.image = image;
        
    	});
	}

串行同步加载的效果如下：

![serialImages](http://7xpcyy.com1.z0.glb.clouddn.com/gcdgif07.gif)

串行异步加载的效果如下：

![serialImages](http://7xpcyy.com1.z0.glb.clouddn.com/gcdgif06.gif)

12张图片依次加载，区别在于同步调用会在所有图片加载完成后才返回，异步调用则不会。

### 并发异步调用

代码于上面的代码相似，`loadImage`方法不同。

	- (void)loadImage{
    
    	for (int i=0; i<row*column; i++) {
        
        	NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        	[imageURL addObject:urlStr];
    	}
    
    	dispatch_queue_t globalQueue = 	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    	for (int i=0;i<row*column;i++) {
        
        	dispatch_async(globalQueue, ^{
            
            	[self loadImageAtIndex:i];
            
        	});
        
    	}
    
	}

效果如下：

![loadImageInConcerrent](http://7xpcyy.com1.z0.glb.clouddn.com/gcdgif01.gif)

#### 任务执行中的顺序控制

利用`dispatch_barrier_async`可以控制执行顺序。该方法创建的任务会先查看队列中有无任务要执行，如果有则会等待任务执行完毕后再执行，同时再此方法后创建的任务都不洗等待该任务完成后才能得以执行。下面演示一下该效果，与上面的代码不同的部分是加载方法。
	
	- (void)loadImage {
    
    	for (int i=0; i<row*column; i++) {
        
        	NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        	[imageURL addObject:urlStr];
    	}
    
    	dispatch_queue_t globalQueue = dispatch_queue_create("rustblogs", DISPATCH_QUEUE_CONCURRENT);
    	dispatch_barrier_async(globalQueue, ^{
        
        	[self loadImageAtIndex:11];
    	});
    
    	for (int i=0;i<row*column-1;i++) {
        
        	dispatch_async(globalQueue, ^{
               
            	[self loadImageAtIndex:i];
               
        	});
    	}
    
	}
	
在代码中我们规定先加载最后一张图片再加载前十一张。效果如图：

![loadImageWithControl](http://7xpcyy.com1.z0.glb.clouddn.com/gcdgif08.gif)

#### 任务的分组管理

	- (void)loadImage
	{
    	for (int i=0; i<row*column; i++) {
        
        	NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        	[imageURL addObject:urlStr];
    	}
    
    	dispatch_group_t group = dispatch_group_create();
    	dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    	dispatch_group_async(group,globalQueue, ^{
        
        	for (int i=0; i<6; i++) {
            	[self loadImageAtIndex:i];
        	}
        
    	});
    
    	dispatch_group_async(group,globalQueue, ^{
        	for (int i=3; i<9; i++) {
            	[self loadImageAtIndex:i];
        	}
    	});
    
    	dispatch_group_notify(group,globalQueue, ^{
        
        	for (int i=9; i<12; i++) {
            	[self loadImageAtIndex:i];
        	}
    	});
	}

代码中我门将12张图片的加载分成3个部分第一次加载6张图片，第二次加载3张图片，将两次任务放入`group`中,`group`中的任务完成后再加载最后3张图片。效果如下：

![loadImageWithControl](http://7xpcyy.com1.z0.glb.clouddn.com/gcdgif09.gif)

#### NSCondition的使用

	- (void)loadImage
	{
    
    	for (int i=0; i<row*column; i++) {
        
        	NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        	[imageURL addObject:urlStr];
    	}
    
    	for (int i=0; i<15; i++) {
        
        	dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            	[self getData];
            
        	});
        
    	}
    
	}

	- (void)getData
	{
    	[condition lock];
    
    	[condition wait];
    	count++;
    	[condition unlock];
    
    	if (imageURL.count>0) {
        	[self loadImageAtIndex:count];
    	}
    
	}

	- (void)loadImageAtIndex:(NSInteger)index
	{
    
    	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageURL lastObject]]]];
    	UIImageView *imageView = [imageViews objectAtIndex:index];
    	dispatch_async(dispatch_get_main_queue(), ^{
            
            	imageView.image = image;
            
    	});
    	[imageURL removeLastObject];
   
	}

	- (void)creatImage
	{
    	dispatch_async(dispatch_get_global_queue(0, 0), ^{
        	[condition signal];
    	});
	}
 
`loadImage`创建15个线程执行`getData`,于`NSLock`不同的是当进入锁中的线程处于 `wait`状态时其他线程是可以进入锁中的。`creatImage`会发出`signal`信号。随机唤醒一个线程进行图片加载和UI更新。效果如下：

![loadImageWithControl](http://7xpcyy.com1.z0.glb.clouddn.com/gcdgif11.gif)















