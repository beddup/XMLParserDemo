//
//  CDCell.m
//  XMLParseDemo
//
//  Created by Amay on 10/29/15.
//  Copyright © 2015 Beddup. All rights reserved.
//

#import "CDCell.h"
#import "CD.h"
@interface CDCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;


@end

@implementation CDCell

-(void)setCd:(CD *)cd{
    _cd = cd;
    self.titleLabel.text = cd.title;
    self.yearLabel.text = cd.year;
    self.priceLabel.text = cd.price;
    self.companyLabel.text = cd.company;
    self.countryLabel.text= cd.country;
    self.artistLabel.text = cd.artist;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
