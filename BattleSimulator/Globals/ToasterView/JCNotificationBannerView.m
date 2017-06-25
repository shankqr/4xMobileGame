
#import "JCNotificationBannerView.h"
#import "CellView.h"

const CGFloat kJCNotificationBannerViewOutlineWidth = 0.0;
const CGFloat kJCNotificationBannerViewMarginX = 5.0;
const CGFloat kJCNotificationBannerViewMarginY = 5.0;

@interface JCNotificationBannerView ()
{
    CellView *cellview;
    BOOL isPresented;
    NSObject *isPresentedMutex;
}

- (void)handleSingleTap:(UIGestureRecognizer*)gestureRecognizer;

@end

@implementation JCNotificationBannerView

@synthesize notificationBanner;

- (id)initWithNotification:(JCNotificationBanner *)notification
{
    self = [super init];
    if (self)
    {
        isPresentedMutex = [NSObject new];
        
        self.backgroundColor = [UIColor clearColor];
        
        cellview = [[CellView alloc] initWithFrame:CGRectZero];
        [cellview setUserInteractionEnabled:NO];
        [self addSubview:cellview];
        
        UITapGestureRecognizer *tapRecognizer;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:tapRecognizer];
        
        self.notificationBanner = notification;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
  CGRect bounds = self.bounds;

  CGFloat lineWidth = kJCNotificationBannerViewOutlineWidth;
  CGFloat radius = 0;
  CGFloat height = bounds.size.height;
  CGFloat width = bounds.size.width;

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetAllowsAntialiasing(context, true);
  CGContextSetShouldAntialias(context, true);

  CGMutablePathRef outlinePath = CGPathCreateMutable();

  CGPathMoveToPoint(outlinePath, NULL, lineWidth, 0);
  CGPathAddLineToPoint(outlinePath, NULL, lineWidth, height - radius - lineWidth);
  CGPathAddArc(outlinePath, NULL, radius + lineWidth, height - radius - lineWidth, radius, -M_PI, M_PI_2, 1);
  CGPathAddLineToPoint(outlinePath, NULL, width - radius - lineWidth, height - lineWidth);
  CGPathAddArc(outlinePath, NULL, width - radius - lineWidth, height - radius - lineWidth, radius, M_PI_2, 0, 1);
  CGPathAddLineToPoint(outlinePath, NULL, width - lineWidth, 0);

  CGContextSetRGBFillColor(context, 0, 0, 0, 0.9);
  CGContextAddPath(context, outlinePath);
  CGContextFillPath(context);

  CGContextAddPath(context, outlinePath);
  CGContextSetRGBFillColor(context, 0, 0, 0, 1);
  CGContextSetLineWidth(context, lineWidth);
  CGContextDrawPath(context, kCGPathStroke);

  CGPathRelease(outlinePath);
}

- (void)layoutSubviews
{
    if (!(self.frame.size.width > 0)) { return; }

    CGFloat cell_width = self.frame.size.width - 20.0f*SCALE_IPAD;
    [cellview drawCell:notificationBanner.dict_cell cellWidth:cell_width];
    CGFloat cell_height = [CellView dynamicCellHeight:notificationBanner.dict_cell cellWidth:cell_width];
    
    if (cell_height > self.frame.size.height)
    {
        CGFloat start_y = self.frame.origin.y + self.frame.size.height - cell_height;
        [self setFrame:CGRectMake(self.frame.origin.x, start_y, self.frame.size.width, cell_height)];
    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (notificationBanner && notificationBanner.tapHandler)
    {
        notificationBanner.tapHandler();
    }
}

- (BOOL)getCurrentPresentingStateAndAtomicallySetPresentingState:(BOOL)state
{
    @synchronized(isPresentedMutex)
    {
        BOOL originalState = isPresented;
        isPresented = state;
        
        return originalState;
    }
}

@end
