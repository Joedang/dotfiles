# How to compress a video for the web with moviepy
import moviepy.editor as mpy
clip = mpy.VideoFileClip('module_wrapping.mp4')
clip = clip.resize(height=240)
clip.write_videofile('module_wrapping_small.mp4', audio=False, preset='slow')