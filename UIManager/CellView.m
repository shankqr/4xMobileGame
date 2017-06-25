//
//  CellView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 4/14/14.
/*
 Copyright © 2017 SHANKAR NATHAN (shankqr@gmail.com). All rights reserved.
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "CellView.h"
#import "RowView.h"
#import "ProgressView.h"
#import "UIManager.h"
#import "DynamicCell.h"

#define CELL_CONTENT_Y (5.0f*SCALE_IPAD)
#define CELL_CONTENT_SPACING (5.0f*SCALE_IPAD)
#define CELL_i0_SPACING (2.0f*SCALE_IPAD)
#define CELL_HEADER_HEIGHT (44.0f*SCALE_IPAD)
#define CELL_HEADER_Y (15.0f*SCALE_IPAD)
#define CELL_LABEL_HEIGHT (20.0f*SCALE_IPAD)
#define CELL_BUTTON_HEIGHT_EXTRA (20.0f*SCALE_IPAD)
#define CELL_DEFAULT_HEIGHT (22.0f*SCALE_IPAD)
#define CELL_FONT_SIZE (17.0f*SCALE_IPAD)

@interface CellView () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) ProgressView *progressView1;
@property (nonatomic, strong) NSDictionary *cellRowData;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *footerImage;
@property (nonatomic, strong) UIImageView *selectedImage;
@property (nonatomic, strong) UITextField *textf1;
@property (nonatomic, strong) UITextView *textv1;
@property (nonatomic, strong) UIImageView *img0;
@property (nonatomic, strong) UIImageView *img1_over;
@property (nonatomic, strong) UIImageView *img2;

@property (nonatomic, assign) BOOL oneLiner;
@property (nonatomic, assign) float cellWidth;

@end

@implementation CellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initCode];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlight
{
    if (highlight && (self.cellRowData[@"h1"] == nil) && (self.cellRowData[@"i2"] != nil))
    {
        [self.selectedImage setHidden:NO];
    }
    else
    {
        [self.selectedImage setHidden:YES];
    }
}

- (void)createTextView
{
    UITextView *ttextv1 = [[UITextView alloc] initWithFrame:CGRectZero];
    [ttextv1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
    ttextv1.returnKeyType = UIReturnKeyDefault;
    ttextv1.delegate = self;
    [ttextv1 setTag:7];
    
    [[ttextv1 layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [[ttextv1 layer] setBorderWidth:2.0f];
    //[[ttextv1 layer] setCornerRadius:15];
    
    [self addSubview:ttextv1];
}

- (void)initCode
{
    self.oneLiner = NO;
    self.backgroundColor = [UIColor clearColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)drawCell:(NSDictionary *)rd cellWidth:(float)cell_width
{
    NSMutableDictionary *rowData = [rd mutableCopy];
    
    self.cellRowData = rowData;
    self.cellWidth = cell_width;
    self.oneLiner = NO;
    
    CGFloat i0_width = 0.0f;
    CGFloat n1_width = 30.0f*SCALE_IPAD;
    CGFloat left_margin = CELL_CONTENT_SPACING;
    CGFloat top_y = CELL_CONTENT_Y;
    CGFloat top_image1_y = 10.0f*SCALE_IPAD;
    CGFloat center_y = CELL_CONTENT_Y;
    CGFloat a1_length = cell_width - CELL_CONTENT_SPACING*2.0f;
    CGFloat c1_length = 0.0f;
    CGFloat e1_length = 0.0f;
    CGFloat g1_length = 0.0f;
    CGFloat a1_height = CELL_LABEL_HEIGHT;
    CGFloat b1_height = 0.0f;
    CGFloat c1_height = 0.0f;
    CGFloat d1_height = 0.0f;
    CGFloat g1_height = 0.0f;
    CGFloat n1_y = 0.0f;
    CGFloat c1_x = 0.0f;
    CGFloat b1_y = 0.0f;
    CGFloat i2_width = 0.0f;
    CGFloat i2_height = 0.0f;
    CGFloat i_width = 0.0f;
    CGFloat i_height = 0.0f;
    CGFloat i_x = 0.0f;
    CGFloat i_y = 0.0f;
    CGFloat cell_height = [DynamicCell dynamicCellHeight:rowData cellWidth:cell_width];
    
    CGRect bkg_frame = CGRectMake(0.0f, 0.0f, cell_width, cell_height);
    [self setFrame:bkg_frame];
    
    if ((self.cellRowData[@"h1"] == nil) && (self.cellRowData[@"i2"] != nil))
    {
        if (!self.selectedImage)
        {
            self.selectedImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        }
        self.selectedImage.contentMode = UIViewContentModeScaleToFill;
        [self.selectedImage setUserInteractionEnabled:NO];
        [self.selectedImage setHidden:YES];
        
        [self.selectedImage setFrame:bkg_frame];
        UIImage *sel_image = [UIManager.i dynamicImage:bkg_frame prefix:@"cell_highlight"];
        [self.selectedImage setImage:sel_image];
        
        [self addSubview:self.selectedImage];
    }
    else
    {
        [self.selectedImage removeFromSuperview];
    }
    
    if ([rowData[@"nofooter"] isEqualToString:@"1"])
    {
        [self.footerImage removeFromSuperview];
    }
    else
    {
        CGFloat f_spacing = 0.0f;
        if (rowData[@"footer_spacing"] != nil && ![rowData[@"footer_spacing"] isEqualToString:@""])
        {
            f_spacing = [rowData[@"footer_spacing"] floatValue]*SCALE_IPAD;
        }
        
        if (!self.footerImage)
        {
            self.footerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        }
        self.footerImage.contentMode = UIViewContentModeScaleToFill;
        [self.footerImage setUserInteractionEnabled:NO];
        [self.footerImage setImage:[UIManager.i imageNamedCustom:@"skin_footer_cell"]];
        [self.footerImage setFrame:CGRectMake(f_spacing, cell_height-(1.0*SCALE_IPAD), cell_width-f_spacing*2, 1.0*SCALE_IPAD)];
        [self addSubview:self.footerImage];
    }
    
    UIImage *bkg_image = nil;
    if (rowData[@"h1"] != nil)
    {
        [rowData addEntriesFromDictionary:@{@"r1" : rowData[@"h1"]}];
        
        [self.footerImage removeFromSuperview];
        bkg_image = [UIManager.i dynamicImage:bkg_frame prefix:@"bkg4"];
        
        top_y = CELL_HEADER_Y;
        center_y = CELL_HEADER_Y;
    }
    else if (rowData[@"bkg_prefix"] != nil)
    {
        bkg_image = [UIManager.i dynamicImage:bkg_frame prefix:rowData[@"bkg_prefix"]];
    }
    else if (rowData[@"bkg"] != nil && ![rowData[@"bkg"] isEqualToString:@""])
    {
        bkg_image = [UIManager.i imageNamedCustom:rowData[@"bkg"]];
    }
    
    if (bkg_image != nil)
    {
        if (!self.backgroundImage)
        {
            self.backgroundImage = [[UIImageView alloc] initWithFrame:bkg_frame];
        }
        self.backgroundImage.contentMode = UIViewContentModeScaleToFill;
        [self.backgroundImage setUserInteractionEnabled:NO];
        [self.backgroundImage setFrame:bkg_frame];
        [self.backgroundImage setImage:bkg_image];
        [self insertSubview:self.backgroundImage atIndex:0];
    }
    else
    {
        [self.backgroundImage removeFromSuperview];
    }
    
    if (rowData[@"n1_width"] != nil && ![rowData[@"n1_width"] isEqualToString:@""])
    {
        n1_width = [rowData[@"n1_width"] floatValue]*SCALE_IPAD;
        top_image1_y = CELL_CONTENT_Y;
    }
    
    if (rowData[@"i0"] != nil && ![rowData[@"i0"] isEqualToString:@""])
    {
        UIImage *i0_image = [UIManager.i imageNamedCustom:rowData[@"i0"]];
        i0_width = i0_image.size.width/2.0f *SCALE_IPAD;
        CGFloat i0_height = i0_image.size.height/2.0f *SCALE_IPAD;
        
        left_margin = i0_width;
        a1_length -= i0_width;
        
        if (!self.img0)
        {
            self.img0 = [[UIImageView alloc] initWithFrame:CGRectZero];
        }
        self.img0.contentMode = UIViewContentModeScaleAspectFit;
        [self.img0 setUserInteractionEnabled:NO];
        [self.img0 setImage:i0_image];
        [self addSubview:self.img0];
        
        [self.img0 setFrame:CGRectMake(CELL_i0_SPACING, CELL_i0_SPACING, i0_width, i0_height)];
    }
    else
    {
        [self.img0 removeFromSuperview];
    }
    
    if (rowData[@"i1"] != nil && ![rowData[@"i1"] isEqualToString:@""])
    {
        left_margin += n1_width + CELL_CONTENT_SPACING;
        a1_length -= n1_width + CELL_CONTENT_SPACING;
        
        if (!self.img1)
        {
            self.img1 = [[UIButton alloc] initWithFrame:CGRectZero];
        }
        [self.img1 setImage:[UIManager.i imageNamedCustom:rowData[@"i1"]] forState:UIControlStateNormal];
        [self addSubview:self.img1];
        
        if (rowData[@"i1_h"] != nil && ![rowData[@"i1_h"] isEqualToString:@""])
        {
            [self.img1 setUserInteractionEnabled:YES];
            if ([rowData[@"i1_h"] isEqualToString:@" "])
            {
                [self.img1 setImage:nil forState:UIControlStateHighlighted];
            }
            else
            {
                [self.img1 setImage:[UIManager.i imageNamedCustom:rowData[@"i1_h"]] forState:UIControlStateHighlighted];
            }
        }
        else
        {
            [self.img1 setUserInteractionEnabled:NO];
            [self.img1 setImage:[UIManager.i imageNamedCustom:rowData[@"i1"]] forState:UIControlStateHighlighted];
        }
        
        if (rowData[@"i1_over"] != nil && ![rowData[@"i1_over"] isEqualToString:@""])
        {
            if (!self.img1_over)
            {
                self.img1_over = [[UIImageView alloc] initWithFrame:CGRectZero];
            }
            self.img1_over.contentMode = UIViewContentModeScaleToFill;
            [self.img1_over setUserInteractionEnabled:NO];
            [self.img1_over setImage:[UIManager.i imageNamedCustom:rowData[@"i1_over"]]];
            [self addSubview:self.img1_over];
        }
        
        if (rowData[@"i1_aspect"] != nil && ![rowData[@"i1_aspect"] isEqualToString:@""])
        {
            self.img1.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else
        {
            self.img1.imageView.contentMode = UIViewContentModeScaleToFill;
        }
    }
    else
    {
        [self.img1 removeFromSuperview];
        [self.img1_over removeFromSuperview];
        
        if (rowData[@"n1"] != nil)
        {
            left_margin += n1_width + CELL_CONTENT_SPACING;
            a1_length -= n1_width + CELL_CONTENT_SPACING;
        }
    }
    
    if ((rowData[@"i2"] != nil) && ![rowData[@"i2"] isEqualToString:@""])
    {
        i2_width = 10.0f*SCALE_IPAD;
        i2_height = 20.0f*SCALE_IPAD;
        
        UIImage *i2_image = [UIManager.i imageNamedCustom:rowData[@"i2"]];
        i2_width = i2_image.size.width/2.0f * SCALE_IPAD;
        i2_height = i2_image.size.height/2.0f * SCALE_IPAD;
        
        if (!self.img2)
        {
            self.img2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        }
        self.img2.contentMode = UIViewContentModeScaleToFill;
        [self.img2 setUserInteractionEnabled:NO];
        [self.img2 setImage:i2_image];
        [self addSubview:self.img2];
        
        a1_length -= i2_width - CELL_CONTENT_SPACING;
    }
    
    if ((rowData[@"c1"] != nil) || (rowData[@"d1"] != nil) || (rowData[@"g1"] != nil))
    {
        CGFloat c1_ratio = 2.0f;
        if (rowData[@"c1_ratio"] != nil && ![rowData[@"c1_ratio"] isEqualToString:@""])
        {
            c1_ratio = [rowData[@"c1_ratio"] floatValue];
            if (c1_ratio < 1.0f || c1_ratio > 10.0f)
            {
                c1_ratio = 2.0f;
            }
        }
        c1_length = a1_length / c1_ratio;
        a1_length -= c1_length;
    }
    
    if ((rowData[@"e1"] != nil && ![rowData[@"e1"] isEqualToString:@""]) || (rowData[@"f1"] != nil  && ![rowData[@"f1"] isEqualToString:@""]))
    {
        e1_length = c1_length;
        a1_length -= c1_length - CELL_CONTENT_SPACING;
    }
    
    if (rowData[@"t1"] != nil)
    {
        CGFloat t1_height = 36.0f * SCALE_IPAD;
        NSInteger t1_keyboard = [rowData[@"t1_keyboard"] integerValue];
        
        if (rowData[@"t1_height"] != nil)
        {
            [self performSelectorOnMainThread:@selector(createTextView) withObject:nil waitUntilDone:YES];
            
            if (!self.textv1)
            {
                self.textv1 = (UITextView*)[self viewWithTag:7];
            }
            self.textv1.autocorrectionType = UITextAutocorrectionTypeNo;
            
            t1_height = [rowData[@"t1_height"] floatValue]*SCALE_IPAD;
            [self.textv1 setFrame:CGRectMake(left_margin, CELL_CONTENT_Y, a1_length, t1_height)];
            
            if (t1_keyboard == 4)
            {
                self.textv1.keyboardType = UIKeyboardTypeEmailAddress;
            }
            else if (t1_keyboard == 5)
            {
                self.textv1.keyboardType = UIKeyboardTypeNumberPad;
            }
            else if (t1_keyboard == 6)
            {
                self.textv1.keyboardType = UIKeyboardTypeNamePhonePad;
            }
            
            self.textv1.returnKeyType = UIReturnKeyDone;
        }
        else
        {
            if (!self.textf1)
            {
                self.textf1 = [[UITextField alloc] initWithFrame:CGRectZero];
            }
            [self.textf1 setMinimumFontSize:1.0f];
            [self.textf1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
            self.textf1.delegate = self;
            [self.textf1 setTag:6];
            [self.textf1 setPlaceholder:rowData[@"t1"]];
            [self.textf1 setFrame:CGRectMake(left_margin, CELL_CONTENT_Y, a1_length, t1_height)];
            self.textf1.secureTextEntry = NO;
            self.textf1.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textf1.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.textf1.returnKeyType = UIReturnKeyDone;
            self.textf1.borderStyle = UITextBorderStyleBezel;
            self.textf1.backgroundColor = [UIColor whiteColor];
            
            if (t1_keyboard == 3)
            {
                self.textf1.secureTextEntry = YES;
            }
            else if (t1_keyboard == 4)
            {
                self.textf1.keyboardType = UIKeyboardTypeEmailAddress;
            }
            else if (t1_keyboard == 5)
            {
                self.textf1.keyboardType = UIKeyboardTypeNumberPad;
            }
            else if (t1_keyboard == 6)
            {
                self.textf1.keyboardType = UIKeyboardTypeNamePhonePad;
            }
            [self addSubview:self.textf1];
        }
    }
    else
    {
        [self.textv1 setFrame:CGRectZero];
        [self.textf1 removeFromSuperview];
    }
    
    if ((rowData[@"r1"] != nil) && ![rowData[@"r1"] isEqualToString:@""])
    {
        if ((rowData[@"r2_slider"] == nil || [rowData[@"r2_slider"] isEqualToString:@""]) && (rowData[@"r2"] == nil || [rowData[@"r2"] isEqualToString:@""]) && (rowData[@"b1"] == nil || [rowData[@"b1"] isEqualToString:@""]) && (rowData[@"i1"] != nil)) //1 line cell with image on left
        {
            top_image1_y = CELL_CONTENT_Y;
            top_y = top_image1_y + ((n1_width/2.0f) - (a1_height/2.0f)); //Center r1
            center_y = top_y;  //Center n1, c1, d1, i1
            
            self.oneLiner = YES; //Buttons y will be 2
        }
        
        CGRect frame = CGRectMake(left_margin, top_y, a1_length, a1_height);
        if (!self.rv_a)
        {
            self.rv_a = [[RowView alloc] initWithFrame:frame];
        }
        self.rv_a.type = @"r";
        self.rv_a.frame_view = frame;
        self.rv_a.rowData = rowData;
        a1_height = [self.rv_a updateView];
        [self addSubview:self.rv_a];
    }
    else
    {
        [self.rv_a removeFromSuperview];
    }
    
    if ((rowData[@"b1"] != nil) && ![rowData[@"b1"] isEqualToString:@""])
    {
        b1_y = top_y+a1_height+CELL_CONTENT_SPACING;
        CGFloat b1_length = a1_length + c1_length; //is not effected by c1
        
        if ((rowData[@"d1"] != nil) && ![rowData[@"d1"] isEqualToString:@""])
        {
            b1_length = a1_length;
        }
        
        if (rowData[@"b1_button"] != nil)
        {
            b1_y = b1_y - CELL_CONTENT_SPACING;
        }
        
        CGRect frame = CGRectMake(left_margin, b1_y, b1_length, b1_height);
        if (!self.rv_b)
        {
            self.rv_b = [[RowView alloc] initWithFrame:frame];
        }
        self.rv_b.type = @"b";
        self.rv_b.frame_view = frame;
        self.rv_b.rowData = rowData;
        b1_height = [self.rv_b updateView];
        [self addSubview:self.rv_b];
    }
    else
    {
        [self.rv_b removeFromSuperview];
    }
    
    //SET n1 y
    n1_y = center_y;
    if (rowData[@"align_top"] != nil)
    {
        n1_y = top_y;
    }
    
    if ((rowData[@"i1"] != nil) && ![rowData[@"i1"] isEqualToString:@""])
    {
        i_width = n1_width;
        i_height = n1_width;
        
        i_y = top_image1_y;
        
        if (i0_width > CELL_CONTENT_SPACING)
        {
            i_x = i0_width + CELL_i0_SPACING;
        }
        else
        {
            i_x = CELL_CONTENT_SPACING;
        }
        
        if (rowData[@"r1"] == nil) //Full image cell
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIManager.i imageNamedCustom:rowData[@"i1"]]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            float image_x = 0.0f;
            float image_y = 0.0f;
            float image_w = 0.0f;
            float image_h = 0.0f;
            if (imageView.image.size.width > cell_width)
            {
                image_w = cell_width;
                image_h = cell_height;
                image_x = 0.0f;
            }
            else
            {
                image_w = imageView.image.size.width;
                image_h = imageView.image.size.height;
                
                if ((rowData[@"i1_width"] != nil) && ![rowData[@"i1_width"] isEqualToString:@""])
                {
                    CGFloat new_i1_width = [rowData[@"i1_width"] doubleValue];
                    
                    image_w = new_i1_width*SCALE_IPAD;
                }
                
                if ((rowData[@"i1_height"] != nil) && ![rowData[@"i1_height"] isEqualToString:@""])
                {
                    CGFloat new_i1_height = [rowData[@"i1_width"] doubleValue];
                    
                    image_h = new_i1_height*SCALE_IPAD;
                }
                
                image_x = (cell_width-image_w)/2.0f; //Center x
            }
            
            [imageView setFrame:CGRectMake(image_x, image_y, image_w, image_h)];
            float widthRatio = imageView.bounds.size.width / image_w;
            float heightRatio = imageView.bounds.size.height / image_h;
            float scale = MIN(widthRatio, heightRatio);
            float imageWidth = scale * image_w;
            float imageHeight = scale * image_h;
            
            if (imageWidth > cell_width)
            {
                i_width = cell_width;
                i_x = 0.0f;
            }
            else
            {
                i_width = imageWidth;
                i_x = (cell_width-imageWidth)/2.0f; //Center x
            }
            
            if ([rowData[@"i1_align"] isEqualToString:@"left"])
            {
                i_x = 0.0f;
            }
            else if ([rowData[@"i1_align"] isEqualToString:@"right"])
            {
                i_x = (cell_width-imageView.image.size.width);
            }
            
            if ((rowData[@"i1_x_p"] != nil) && ![rowData[@"i1_x_p"] isEqualToString:@""])
            {
                i_x = i_x*[rowData[@"i1_x_p"] doubleValue];
            }
            else if ((rowData[@"i1_x"] != nil) && ![rowData[@"i1_x"] isEqualToString:@""])
            {
                i_x = i_x+[rowData[@"i1_x"] doubleValue];
            }
            
            if ((rowData[@"i1_y_p"] != nil) && ![rowData[@"i1_y_p"] isEqualToString:@""])
            {
                i_y = i_y*[rowData[@"i1_y_p"] doubleValue];
            }
            else if ((rowData[@"i1_y"] != nil) && ![rowData[@"i1_y"] isEqualToString:@""])
            {
                i_y = i_y+[rowData[@"i1_y"] doubleValue];
            }
            
            
            i_y = 0.0f;
            i_height = imageHeight;
        }
        
        [self.img1 setFrame:CGRectMake(i_x, i_y, i_width, i_height)];
        
        if ((rowData[@"i1_over"] != nil) && ![rowData[@"i1_over"] isEqualToString:@""])
        {
            [self.img1_over setFrame:CGRectMake(i_x, i_y, i_width, i_height)];
        }
        else
        {
            [self.img1_over setFrame:CGRectZero];
        }
        
        //center_y = 14.0f*SCALE_IPAD;
        
        n1_y = i_y + i_height + CELL_CONTENT_SPACING;
        
        if (rowData[@"p1"] != nil)
        {
            CGFloat progress_x = 0;
            CGFloat progress_y = 0;
            CGFloat progress_height = 16.0f*SCALE_IPAD;
            CGFloat progress_width = 160.0f*SCALE_IPAD;
            
            if (rowData[@"p1_width_p"] != nil)
            {
                progress_width = cell_width*[rowData[@"p1_width_p"] doubleValue]- CELL_CONTENT_SPACING*2.0f;
            }
            else if (rowData[@"p1_width"] != nil)
            {
                progress_width = [rowData[@"p1_width"] doubleValue]*SCALE_IPAD;
            }
            
            if (rowData[@"p1_height_p"] != nil)
            {
                progress_height = progress_height*[rowData[@"p1_height_p"] doubleValue];
            }
            else if (rowData[@"p1_height"] != nil)
            {
                progress_height = [rowData[@"p1_height"] doubleValue]*SCALE_IPAD;
            }
            
            if (rowData[@"p1_y_p_cell"] != nil) //Percentage of cell height
            {
                progress_y = cell_height * [rowData[@"p1_y_p_cell"] doubleValue];
            }
            else if (rowData[@"p1_y_p"] != nil)
            {
                progress_y = i_y * [rowData[@"p1_y_p"] doubleValue];
            }
            else if (rowData[@"p1_y"] != nil)
            {
                progress_y = i_y + i_height + ([rowData[@"p1_y"] doubleValue]*SCALE_IPAD);
                
                int over_cell_height = (progress_y+ progress_height+ CELL_CONTENT_SPACING*2.0f) -cell_height;
                if (over_cell_height>0)
                {
                    progress_y = progress_y - over_cell_height;
                }
            }
            else
            {
                if ((rowData[@"c1_button"] != nil && ![rowData[@"c1_button"] isEqualToString:@""])||(rowData[@"d1_button"] != nil && ![rowData[@"d1_button"] isEqualToString:@""])||(rowData[@"r1_button"] != nil && ![rowData[@"r1_button"] isEqualToString:@""]))
                {
                    progress_y = (n1_y) + CELL_BUTTON_HEIGHT_EXTRA;
                }
                else
                {
                    progress_y = (n1_y);
                }
            }
            
            if (rowData[@"p1_x_p_cell"] != nil)
            {
               progress_x = cell_width * [rowData[@"p1_x_p_cell"] doubleValue];
            }
            else if (rowData[@"p1_x_p"] != nil)
            {
                progress_x = (i_x+i_width) * [rowData[@"p1_x_p"] doubleValue];
            }
            else if (rowData[@"p1_x"] != nil)
            {
                progress_x = (i_x+i_width) + ([rowData[@"p1_x"] doubleValue]*SCALE_IPAD);
            }
            else
            {
                progress_x = (i_x);
            }
            
            
            if (!self.progressView1)
            {
                self.progressView1 = [[ProgressView alloc] initWithFrame:CGRectMake(progress_x, progress_y, progress_width, progress_height)];
            }
            
            [self.progressView1 setFrame:CGRectMake(progress_x, progress_y, progress_width, progress_height)];
            self.progressView1.bar1 = [rowData[@"p1"] floatValue];
            self.progressView1.barText = rowData[@"p1_text"];
            
            if (rowData[@"p1_color"] != nil && [rowData[@"p1_color"] isEqualToString:@"1"])
            {
                [self.progressView1 barRed];
            }
            else
            {
                [self.progressView1 barBlue];
            }
            
            [self.progressView1 updateView];
            
            //NSLog(@"progress_y: %@", @(progress_y));
            
            [self addSubview:self.progressView1];
        }
        else
        {
            [self.progressView1 removeFromSuperview];
        }
    }
    else
    {
        [self.img1 removeFromSuperview];
        [self.img1_over removeFromSuperview];
        
        if (rowData[@"p1"] != nil)
        {
            CGFloat progress_x = 0;
            CGFloat progress_y = 0;
            CGFloat progress_height = 16.0f*SCALE_IPAD;
            CGFloat progress_width = 160.0f*SCALE_IPAD;
            
            if (rowData[@"p1_width_p"] != nil)
            {
                progress_width = cell_width*[rowData[@"p1_width_p"] doubleValue]- CELL_CONTENT_SPACING*2.0f;
            }
            
            if (rowData[@"p1_height_p"] != nil)
            {
                progress_height = progress_height*[rowData[@"p1_height_p"] doubleValue];
            }
            
            if (rowData[@"p1_y_p_cell"] != nil)
            {
                progress_y = cell_height*[rowData[@"p1_y_p_cell"] doubleValue];
            }
            else if (rowData[@"p1_y"] != nil)
            {
                progress_y = ([rowData[@"p1_y"] doubleValue]*SCALE_IPAD);
                
                int over_cell_height = (progress_y+ progress_height+ CELL_CONTENT_SPACING*2.0f) -cell_height;
                if(over_cell_height>0)
                {
                    progress_y = progress_y - over_cell_height;
                }
            }
            
            if (rowData[@"p1_x_p_cell"] != nil)
            {
                progress_x = cell_width*[rowData[@"p1_x_p_cell"] doubleValue];
            }
            else if (rowData[@"p1_x"] != nil)
            {
                progress_x = ([rowData[@"p1_x"] doubleValue]*SCALE_IPAD );
            }
            
            if (!self.progressView1)
            {
                self.progressView1 = [[ProgressView alloc] initWithFrame:CGRectMake(progress_x, progress_y, progress_width, progress_height)];
            }
            
            [self.progressView1 setFrame:CGRectMake(progress_x, progress_y, progress_width, progress_height)];
            self.progressView1.bar1 = [rowData[@"p1"] floatValue];
            self.progressView1.barText = rowData[@"p1_text"];
            
            if (rowData[@"p1_color"] != nil && [rowData[@"p1_color"] isEqualToString:@"1"])
            {
                [self.progressView1 barRed];
            }
            else
            {
                [self.progressView1 barBlue];
            }
            
            [self.progressView1 updateView];
            [self addSubview:self.progressView1];
            
            n1_y = progress_y + progress_height + CELL_CONTENT_SPACING;
        }
        else
        {
            [self.progressView1 removeFromSuperview];
        }
        
    }
    
    if ((rowData[@"n1"] != nil) && ![rowData[@"n1"] isEqualToString:@""])
    {
        CGRect frame = CGRectMake(CELL_CONTENT_SPACING, n1_y, n1_width, CELL_LABEL_HEIGHT);
        
        if (!self.rv_n)
        {
            self.rv_n = [[RowView alloc] initWithFrame:frame];
        }
        self.rv_n.type = @"n";
        self.rv_n.frame_view = frame;
        self.rv_n.rowData = rowData;
        [self.rv_n updateView];
        [self addSubview:self.rv_n];
    }
    else
    {
        [self.rv_n removeFromSuperview];
    }
    
    c1_x = left_margin+a1_length+CELL_CONTENT_SPACING;
    CGFloat c1_y = 0.0;
    
    if ((rowData[@"c1"] != nil) && ![rowData[@"c1"] isEqualToString:@""])
    {
        c1_y = top_y;
        
        if ((rowData[@"c1_button"] != nil) && (rowData[@"r1_button"] == nil) && self.oneLiner)
        {
            c1_y = SCALE_IPAD;
            //c1_length = c1_length + CELL_CONTENT_SPACING;
            
        }
        
        CGRect frame = CGRectMake(c1_x, c1_y, c1_length-CELL_CONTENT_SPACING, c1_height);
        if (!self.rv_c)
        {
            self.rv_c = [[RowView alloc] initWithFrame:frame];
        }
        self.rv_c.type = @"c";
        self.rv_c.frame_view = frame;
        self.rv_c.rowData = rowData;
        c1_height = [self.rv_c updateView];
        [self addSubview:self.rv_c];
    }
    else
    {
        [self.rv_c removeFromSuperview];
    }
    
    if ((rowData[@"g1"] != nil) && ![rowData[@"g1"] isEqualToString:@""])
    {
        if ((rowData[@"d1"] != nil) && ![rowData[@"d1"] isEqualToString:@""])
        {
            CGFloat d1_y = c1_y+c1_height*2;
            CGRect frame = CGRectMake(c1_x, d1_y, c1_length-CELL_CONTENT_SPACING, d1_height);
            if (!self.rv_d)
            {
                self.rv_d = [[RowView alloc] initWithFrame:frame];
            }
            self.rv_d.type = @"d";
            self.rv_d.frame_view = frame;
            self.rv_d.rowData = rowData;
            d1_height = [self.rv_d updateView];
            [self addSubview:self.rv_d];
            
            CGFloat g1_y = d1_y + d1_height*2;
            
            frame = CGRectMake(c1_x, g1_y, c1_length-CELL_CONTENT_SPACING, g1_height);
            if (!self.rv_g)
            {
                self.rv_g = [[RowView alloc] initWithFrame:frame];
            }
            self.rv_g.type = @"g";
            self.rv_g.frame_view = frame;
            self.rv_g.rowData = rowData;
            g1_height = [self.rv_g updateView];
            [self addSubview:self.rv_g];
            
        }
        else
        {
            if ((rowData[@"c1"] != nil) && ![rowData[@"c1"] isEqualToString:@""])
            {
                [self.rv_d removeFromSuperview];
                
                CGFloat g1_y = c1_y + c1_height*2;
                
                CGRect frame = CGRectMake(c1_x, g1_y, c1_length-CELL_CONTENT_SPACING, g1_height);
                if (!self.rv_g)
                {
                    self.rv_g = [[RowView alloc] initWithFrame:frame];
                }
                self.rv_g.type = @"g";
                self.rv_g.frame_view = frame;
                self.rv_g.rowData = rowData;
                g1_height = [self.rv_g updateView];
                [self addSubview:self.rv_g];
            }
            else
            {
                [self.rv_d removeFromSuperview];
                
                CGFloat g1_y = top_y;
                CGFloat g1_x = left_margin+a1_length+CELL_CONTENT_SPACING;
                CGFloat g1_ratio = 2.0;
                if ((rowData[@"g1_ratio"] != nil) && ![rowData[@"g1_ratio"] isEqualToString:@""])
                {
                    g1_ratio = [rowData[@"g1_ratio"] floatValue];
                    if (g1_ratio < 1.0f || g1_ratio > 10.0f)
                    {
                        g1_ratio = 2.0f;
                    }
                }
                
                if(g1_ratio!=0)
                {
                    g1_length = a1_length / g1_ratio;
                }
                else
                {
                    g1_length = a1_length;
                }
                
                a1_length -= g1_length;
                
                CGRect frame = CGRectMake(g1_x, g1_y, g1_length-CELL_CONTENT_SPACING, g1_height);
                if (!self.rv_g)
                {
                    self.rv_g = [[RowView alloc] initWithFrame:frame];
                }
                self.rv_g.type = @"g";
                self.rv_g.frame_view = frame;
                self.rv_g.rowData = rowData;
                g1_height = [self.rv_g updateView];
                [self addSubview:self.rv_g];
            }
        }
    }
    else
    {
        [self.rv_g removeFromSuperview];
        
        if ((rowData[@"d1"] != nil) && ![rowData[@"d1"] isEqualToString:@""])
        {
            CGFloat d1_y = top_y+c1_height+CELL_CONTENT_SPACING;
            
            if (b1_y > d1_y)
            {
                d1_y = b1_y;
            }
            
            if (rowData[@"d1_button"] != nil)
            {
                d1_y = d1_y - CELL_CONTENT_SPACING;
                if(rowData[@"b1"] == nil || [rowData[@"b1"] isEqualToString:@""])
                {
                    d1_y = d1_y +CELL_CONTENT_SPACING*2;
                }
            }
            
            CGRect frame = CGRectMake(c1_x, d1_y, c1_length-CELL_CONTENT_SPACING, d1_height);
            if (!self.rv_d)
            {
                self.rv_d = [[RowView alloc] initWithFrame:frame];
            }
            self.rv_d.type = @"d";
            self.rv_d.frame_view = frame;
            self.rv_d.rowData = rowData;
            d1_height = [self.rv_d updateView];
            [self addSubview:self.rv_d];
        }
        else
        {
            [self.rv_d removeFromSuperview];
        }

    }
    
    if ((rowData[@"e1"] != nil) && ![rowData[@"e1"] isEqualToString:@""])
    {
        CGFloat e1_y = top_y;
        
        CGFloat e1_x = left_margin+a1_length+CELL_CONTENT_SPACING+c1_length;
        
        if ((rowData[@"e1_button"] != nil) && self.oneLiner)
        {
            e1_y = SCALE_IPAD;
            //e1_length = e1_length + CELL_CONTENT_SPACING;
        }
        
        CGRect frame = CGRectMake(e1_x, e1_y, e1_length-CELL_CONTENT_SPACING*2, CELL_LABEL_HEIGHT);
        if (!self.rv_e)
        {
            self.rv_e = [[RowView alloc] initWithFrame:frame];
        }
        self.rv_e.type = @"e";
        self.rv_e.frame_view = frame;
        self.rv_e.rowData = rowData;
        [self.rv_e updateView];
        [self addSubview:self.rv_e];
    }
    else
    {
        [self.rv_e removeFromSuperview];
    }
    
    if ((rowData[@"i2"] != nil) && ![rowData[@"i2"] isEqualToString:@""])
    {
        float img2_y;
        
        if ((rowData[@"i1"] != nil) && (n1_width > (a1_height+b1_height)))
        {
            img2_y = top_image1_y + (n1_width)/2.0f - i2_height/2.0f;
        }
        else
        {
            img2_y = top_y + (a1_height+b1_height)/2.0f - i2_height/2.0f;
        }
        
        [self.img2 setFrame:CGRectMake(left_margin+a1_length+c1_length+e1_length, img2_y, i2_width, i2_height)];
    }
    else
    {
        [self.img2 removeFromSuperview];
    }
}

+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width
{
    NSMutableDictionary *rowData = [rd mutableCopy];
    
    if ((rowData[@"i1"] != nil) && (rowData[@"r1"] == nil) && (rowData[@"p1"] == nil)) //Full image cell
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIManager.i imageNamedCustom:rowData[@"i1"]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        float image_x = 0.0f;
        float image_y = 0.0f;
        float image_w = 0.0f;
        if (imageView.image.size.width > cell_width)
        {
            image_w = cell_width;
            image_x = 0.0f;
        }
        else
        {
            image_w = imageView.image.size.width;
            image_x = (cell_width-imageView.image.size.width)/2.0f; //Center x
        }
        [imageView setFrame:CGRectMake(image_x, image_y, image_w, imageView.image.size.height)];
        float widthRatio = imageView.bounds.size.width / imageView.image.size.width;
        float heightRatio = imageView.bounds.size.height / imageView.image.size.height;
        float scale = MIN(widthRatio, heightRatio);
        //float imageWidth = scale * imageView.image.size.width;
        float imageHeight = scale * imageView.image.size.height;
        
        return imageHeight;
    }
    
    CGFloat n1_width = 0.0f;
    CGFloat cell_height = 15.0f*SCALE_IPAD;
    CGFloat r1_length = cell_width - CELL_CONTENT_SPACING*2.0f;
    CGFloat c1_length = 0.0f;
    CGFloat g1_length = 0.0f;
    CGFloat i2_width = 0.0f;
    CGFloat t1_height = 36.0f*SCALE_IPAD;
    CGFloat b1_height = 0.0f;
    
    if (rowData[@"fit"] != nil && ![rowData[@"fit"] isEqualToString:@""])
    {
        cell_height = 2.0f*SCALE_IPAD;
    }
    
    if (rowData[@"n1_width"] != nil && ![rowData[@"n1_width"] isEqualToString:@""])
    {
        n1_width = [rowData[@"n1_width"] floatValue]*SCALE_IPAD;
    }
    
    if ((rowData[@"n1"] != nil && ![rowData[@"n1"] isEqualToString:@""]) || (rowData[@"i1"] != nil && ![rowData[@"i1"] isEqualToString:@""]))
    {
        if (n1_width == 0.0f)
        {
            n1_width = 30.0f*SCALE_IPAD;
        }
        r1_length -= n1_width + CELL_CONTENT_SPACING;
    }
    
    if (rowData[@"i0"] != nil && ![rowData[@"i0"] isEqualToString:@""])
    {
        UIImage *i0_image = [UIManager.i imageNamedCustom:rowData[@"i0"]];
        CGFloat i0_width = i0_image.size.width/2.0f * SCALE_IPAD;
        
        r1_length -= i0_width + CELL_i0_SPACING;
    }
    
    if (rowData[@"i2"] != nil && ![rowData[@"i2"] isEqualToString:@""])
    {
        i2_width = 10.0f*SCALE_IPAD;
        
        if (![rowData[@"i2"] isEqualToString:@""])
        {
            UIImage *i2_image = [UIManager.i imageNamedCustom:rowData[@"i2"]];
            i2_width = i2_image.size.width/2.0f * SCALE_IPAD;
        }
        
        r1_length -= i2_width;
    }
    
    if ((rowData[@"c1"] != nil) || (rowData[@"d1"] != nil))
    {
        CGFloat c1_ratio = 2.0f;
        if (rowData[@"c1_ratio"] != nil && ![rowData[@"c1_ratio"] isEqualToString:@""])
        {
            c1_ratio = [rowData[@"c1_ratio"] floatValue];
            if (c1_ratio < 1.0f || c1_ratio > 10.0f)
            {
                c1_ratio = 2.0f;
            }
        }
        c1_length = r1_length / c1_ratio;
        r1_length -= c1_length;
    }
    
    if ((rowData[@"g1"] != nil))
    {
        CGFloat g1_ratio = 2.0f;
        if (rowData[@"g1_ratio"] != nil && ![rowData[@"g1_ratio"] isEqualToString:@""])
        {
            g1_ratio = [rowData[@"g1_ratio"] floatValue];
            if (g1_ratio < 1.0f || g1_ratio > 10.0f)
            {
                g1_ratio = 2.0f;
            }
        }
        
        if(g1_ratio!= 0)
        {
            g1_length = r1_length / g1_ratio;
        }
        else
        {
            g1_length = r1_length;
        }
        
        r1_length -= g1_length;
    }
    
    if (rowData[@"e1"] != nil && ![rowData[@"e1"] isEqualToString:@""])
    {
        r1_length -= c1_length + CELL_CONTENT_SPACING;
    }
    
    /// V is HEIGHT calculation 
    
    if ((rowData[@"r1"] != nil) && ![rowData[@"r1"] isEqualToString:@""])
    {
        CGRect frame = CGRectMake(0.0f, 0.0f, r1_length, 0.0f);
        RowView *rv = [[RowView alloc] initWithFrame:frame];
        rv.type = @"r";
        rv.frame_view = frame;
        rv.rowData = rowData;
        CGFloat r1_height = [rv updateView];
        
        cell_height += r1_height;
        
        if (rowData[@"r1_button"] != nil && ![rowData[@"r1_button"] isEqualToString:@""]) //r1 has a button
        {
            if (rowData[@"fit"] != nil && ![rowData[@"fit"] isEqualToString:@""])
            {
                cell_height += 1.0f*SCALE_IPAD;;
            }
            else
            {
                cell_height += CELL_BUTTON_HEIGHT_EXTRA;
            }
        }
    }
    
    if ((rowData[@"r2"] != nil) && ![rowData[@"r2"] isEqualToString:@""])
    {
        if (rowData[@"fit"] != nil && ![rowData[@"fit"] isEqualToString:@""])
        {
            cell_height += 1.0f*SCALE_IPAD;;
        }
    }
    
    if ((rowData[@"r3"] != nil) && ![rowData[@"r3"] isEqualToString:@""])
    {
        if (rowData[@"fit"] != nil && ![rowData[@"fit"] isEqualToString:@""])
        {
            cell_height += 1.0f*SCALE_IPAD;;
        }
    }
    
    if ((rowData[@"r4"] != nil) && ![rowData[@"r4"] isEqualToString:@""])
    {
        if (rowData[@"fit"] != nil && ![rowData[@"fit"] isEqualToString:@""])
        {
            cell_height += 1.0f*SCALE_IPAD;;
        }
    }
    
    if ((rowData[@"b1"] != nil) && ![rowData[@"b1"] isEqualToString:@""])
    {
        CGRect frame = CGRectMake(0.0f, 0.0f, r1_length, 0.0f);
        RowView *rv = [[RowView alloc] initWithFrame:frame];
        rv.type = @"b";
        rv.frame_view = frame;
        rv.rowData = rowData;
        b1_height = [rv updateView];
        
        cell_height += b1_height;
        
        if (rowData[@"b1_button"] != nil && ![rowData[@"b1_button"] isEqualToString:@""]) //b1 has a button
        {
            if (rowData[@"fit"] != nil && ![rowData[@"fit"] isEqualToString:@""])
            {
                cell_height += 1.0f*SCALE_IPAD;
            }
            else
            {
                cell_height += CELL_BUTTON_HEIGHT_EXTRA;
            }
        }
        else
        {
            CGFloat row_count = 0;
            CGFloat cell_height_row_height =0;
            
            if (rowData[@"d1"] != nil && ![rowData[@"d1"] isEqualToString:@""])
            {
                row_count ++;
            }
            
            if (rowData[@"g1"] != nil && ![rowData[@"g1"] isEqualToString:@""])
            {
                row_count ++;
            }
            
            if (rowData[@"c1"] != nil && ![rowData[@"c1"] isEqualToString:@""])
            {
                row_count ++;
            }
            
            cell_height_row_height = (1.0f*SCALE_IPAD*(row_count));
            
            CGFloat button_count = 0;
            CGFloat cell_height_button_height =0;
            
            if (rowData[@"d1_button"] != nil && ![rowData[@"d1_button"] isEqualToString:@""])
            {
                button_count ++;
            }
            
            if (rowData[@"g1_button"] != nil && ![rowData[@"g1_button"] isEqualToString:@""])
            {
                button_count ++;
            }
            
            if (rowData[@"c1_button"] != nil && ![rowData[@"c1_button"] isEqualToString:@""])
            {
                button_count ++;
            }
            
            cell_height_button_height = (CELL_BUTTON_HEIGHT_EXTRA*(button_count)*2);

            if (cell_height_row_height>cell_height_button_height)
            {
                if (cell_height_row_height>0)
                {
                    if (cell_height_button_height>cell_height)
                    {
                        cell_height = cell_height_row_height;
                    }
                }
            }
            else
            {
                if (cell_height_button_height>0)
                {
                    if (cell_height_button_height>cell_height)
                    {
                        cell_height = cell_height_button_height;
                    }
                }
            }
                
        }
    }
    
    if ((rowData[@"i1"] != nil) && ![rowData[@"i1"] isEqualToString:@""])
    {
        CGFloat column1_height = n1_width;
        
        if (rowData[@"n1"] != nil && ![rowData[@"n1"] isEqualToString:@""])
        {
            column1_height += 20.0f*SCALE_IPAD;
        }
        
        if (rowData[@"n1_button"] != nil && ![rowData[@"n1_button"] isEqualToString:@""])
        {
            column1_height += 15.0f*SCALE_IPAD;
        }
        
        if (rowData[@"n2"] != nil && ![rowData[@"n2"] isEqualToString:@""])
        {
            column1_height += 20.0f*SCALE_IPAD;
        }
        
        if (column1_height >= cell_height-CELL_CONTENT_SPACING)
        {
            cell_height = column1_height;
            
            if (rowData[@"fit"] == nil)
            {
                cell_height += CELL_CONTENT_SPACING*2;
            }
        }
        
        if (rowData[@"p1"] != nil) //There is a progressbar bellow image
        {
            if (rowData[@"p1_y_p_cell"] != nil) //Percentage of cell height
            {
                
            }
            else if (rowData[@"p1_y_p"] != nil)
            {
                
            }
            else if (rowData[@"p1_y"] != nil)
            {
                
            }
            else
            {
                //NSLog(@"column1_height: %@", @(column1_height)); //64
                //NSLog(@"cell_height: %@", @(cell_height)); //98.5
                
                CGFloat pb_y = column1_height + 30.0f*SCALE_IPAD;
                
                CGFloat pb_height = 16.0f*SCALE_IPAD + CELL_CONTENT_SPACING;
                
                if (pb_y+pb_height > cell_height)
                {
                    cell_height = pb_y+pb_height;
                }
                
                //NSLog(@"NEW cell_height: %@", @(cell_height));
            }
        }
    }

    if (rowData[@"t1"] != nil)
    {
        if (rowData[@"t1_height"] != nil)
        {
            t1_height = [rowData[@"t1_height"] floatValue]*SCALE_IPAD;
            cell_height += t1_height;
        }
        else
        {
            cell_height += t1_height;
        }
    }
    
    if (rowData[@"h1"] != nil && ![rowData[@"h1"] isEqualToString:@""])
    {
        cell_height = CELL_HEADER_HEIGHT;
    }
    
    if (rowData[@"r1_extra_line"] != nil)
    {
        if ([rowData[@"r1_extra_line"] integerValue]>0)
        {
            cell_height += CELL_CONTENT_SPACING*[rowData[@"r1_extra_line"] integerValue];
        }
    }
    
    if (rowData[@"extra_cell_height"] != nil && ![rowData[@"extra_cell_height"] isEqualToString:@""])
    {
        cell_height += ([rowData[@"extra_cell_height"] doubleValue]*SCALE_IPAD);
    }
    
    return cell_height;
}

@end
