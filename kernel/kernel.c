void main()
{
    char *video_memory = (char*) 0xb8000;
    for (int i=0; i < 80; i++)
        video_memory += 2;
    *video_memory = 0x20;
    video_memory++;
    *video_memory = 0x40;
}
