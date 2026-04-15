## Small changes:
- [ ] Define range of valid Blender versions, show warning if invalid
- [ ] Better error handling in general, too many bug reports of people saying "it doesn't work" even when the issue is simple
- [ ] Allow for inconsistant exposure brackets - currently the first exposure set determines how many images there are per set, but it should be possible to support exposure sets with varying numbers of images.

## Big changes:
- [ ] Replace Blender merging with custom solution that includes deghosting & weighted merging to reduce noise. Possibly built with [OpenCV](https://learnopencv.com/high-dynamic-range-hdr-imaging-using-opencv-cpp-python)
- [ ] Either expose options for align_image_stack.exe, or replace with [OpenCV implementation](https://github.com/khufkens/align_images/blob/master/align_images.py)
