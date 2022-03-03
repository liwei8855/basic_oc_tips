//
//  AsyncReadUtil.m
//  basic_tips
//
//  Created by 李威 on 2021/11/8.
//

#import "AsyncReadUtil.h"

@implementation AsyncReadUtil

//分割读取文件
- (void)readFile:(NSString *)filePath {
    dispatch_queue_t pipe_q = dispatch_queue_create("PipeQ", NULL);
    dispatch_fd_t fd = 0;
    dispatch_io_t pipe_channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, pipe_q, ^(int error) {
        close(fd);
    });
//    *out_fd =
    //设定一次读取的大小
    dispatch_io_set_low_water(pipe_channel, SIZE_MAX);
    //并列读取
    dispatch_io_read(pipe_channel, 0, SIZE_MAX, pipe_q, ^(bool done, dispatch_data_t  _Nullable data, int error) {
        if (error == 0) {
            size_t len = dispatch_data_get_size(data);
            if (len > 0) {
                const char *bytes = NULL;
                char *encoded;
                dispatch_data_t md = dispatch_data_create_map(data, (const void **)&bytes, &len);
                
            }
        }
        
        if (done) {
//            dispatch_semaphore_signal(sem);
        }
    });
}

@end
