//
//  DeWuViewController.m
//  ARExample
//
//  Created by allen0828 on 2022/12/8.
//

#import "DeWuViewController.h"
#import <ARKit/ARKit.h>

static SCNMatrix4 matrix_from_rotation(float radians, float x, float y, float z)
{
//    vector_float3 v = vector_normalize(((vector_float3){x, y, z}));
//    float cos = cosf(radians);
//    float cosp = 1.0f - cos;
//    float sin = sinf(radians);
//    SCNMatrix4 m = {
//        .columns[0] = { cos + cosp * v.x * v.x, cosp * v.x * v.y + v.z * sin, cosp * v.x * v.z - v.y * sin, 0.0f, },
//        .columns[1] = { cosp * v.x * v.y - v.z * sin, cos + cosp * v.y * v.y, cosp * v.y * v.z + v.x * sin, 0.0f, },
//        .columns[2] = { cosp * v.x * v.z + v.y * sin, cosp * v.y * v.z - v.x * sin, cos + cosp * v.z * v.z, 0.0f, },
//        .columns[3] = { 0.0f, 0.0f, 0.0f, 1.0f }
//    };
//    return m;
    return SCNMatrix4MakeRotation(radians, x, y, z);
}


@interface DeWuViewController ()

@property (nonatomic,strong) SCNView *scene;

@end

@implementation DeWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"得物试衣间";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.scene = [[SCNView alloc] initWithFrame:
                  CGRectMake(0, 88, self.view.frame.size.width, 200)];
    self.scene.backgroundColor = UIColor.lightGrayColor;
    self.scene.allowsCameraControl = true;
    SCNScene *rootScene = [SCNScene scene];
    self.scene.scene = rootScene;
    [self.view addSubview:self.scene];
     

    
    [self addBoxGeometry];
    [self addAppleWatch];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80, 400, self.view.frame.size.width-160, 50)];
    btn.backgroundColor = UIColor.redColor;
    [btn setTitle:@"模型加载中..." forState:UIControlStateNormal];
    [self.view addSubview:btn];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [btn setTitle:@"点击试穿" forState:UIControlStateNormal];
    });
}

- (void)addBoxGeometry
{
    SCNBox *box = [SCNBox new];
    SCNMaterial *material = box.materials.firstObject;
    UIImage *img = [UIImage imageNamed:@"bricks"];
    material.diffuse.contents = img;
    SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
    boxNode.transform = SCNMatrix4MakeRotation(M_PI/2, 1, 1, 1);
    
    [self.scene.scene.rootNode addChildNode:boxNode];
}
- (void)addAppleWatch
{
    dispatch_queue_t _loadQueue = dispatch_queue_create("load_assets", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_loadQueue, ^{
        SCNScene *scene = [SCNScene sceneNamed:@"AppleWatch.usdz"];
        SCNNode *watchNode = scene.rootNode.childNodes[0];
        SCNNode *watchRoot = [SCNNode node];
        watchRoot.position = SCNVector3Make(-0.5, -0.8, -0.5);
        watchRoot.scale = SCNVector3Make(0.2, 0.2, 0.2);
        [watchRoot addChildNode:watchNode];
        [self.scene.scene.rootNode addChildNode:watchRoot];
    });
}



@end
//matrix_from_rotation(M_PI/2, 1, 1, 1);
