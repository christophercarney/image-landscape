import argparse
from PIL import Image

def output_analysis(path):
    img_file = Image.open("forrest.jpg")
    img = img_file.load()

    # (2) Get image width & height in pixels split into quadrants
    [xs, ys] = img_file.size
    q1 = [(0, 0), (xs/2, ys/2)]
    q2 = [(xs/2,0), (xs,ys/2)]
    q3 = [(0,ys/2), (xs/2,ys)]
    q4 = [(xs/2,ys/2), (xs,ys)]
    q5 = [(xs/4,ys/4),((3*xs)/4,(3*ys)/4)]

    print((xs, ys, q1, q2, q3, q4, q5))

    q1_rgb = [0, 0, 0]
    q2_rgb = [0, 0, 0]
    q3_rgb = [0, 0, 0]
    q4_rgb = [0, 0, 0]
    q5_rgb = [0, 0, 0]
 
    count=0
    for x in range(int(q1[0][0]), int(q1[1][0])):
      for y in range(int(q1[0][1]), int(q1[1][1])):
        # (4)  Get the RGB color of the pixel
        [r, g, b] = img[x, y]

        q1_rgb[0] += r
        q1_rgb[1] += g
        q1_rgb[2] += b

        count += 1

    q1_rgb[0] /= count
    q1_rgb[1] /= count
    q1_rgb[2] /= count

    q1_rgb = list(map(int, q1_rgb))

    print(q1_rgb)

    count=0
    for x in range(int(q2[0][0]), int(q2[1][0])):
      for y in range(int(q2[0][1]), int(q2[1][1])):
        # (4)  Get the RGB color of the pixel
        [r, g, b] = img[x, y]

        q2_rgb[0] += r
        q2_rgb[1] += g
        q2_rgb[2] += b

        count += 1

    q2_rgb[0] /= count
    q2_rgb[1] /= count
    q2_rgb[2] /= count

    q2_rgb = list(map(int, q2_rgb))

    print(q2_rgb)

    count=0
    for x in range(int(q3[0][0]), int(q3[1][0])):
      for y in range(int(q3[0][1]), int(q3[1][1])):
        # (4)  Get the RGB color of the pixel
        [r, g, b] = img[x, y]

        q3_rgb[0] += r
        q3_rgb[1] += g
        q3_rgb[2] += b

        count += 1

    q3_rgb[0] /= count
    q3_rgb[1] /= count
    q3_rgb[2] /= count

    q3_rgb = list(map(int, q3_rgb))

    print(q3_rgb)

    count=0
    for x in range(int(q4[0][0]), int(q4[1][0])):
      for y in range(int(q4[0][1]), int(q4[1][1])):
        # (4)  Get the RGB color of the pixel
        [r, g, b] = img[x, y]

        q4_rgb[0] += r
        q4_rgb[1] += g
        q4_rgb[2] += b

        count += 1

    q4_rgb[0] /= count
    q4_rgb[1] /= count
    q4_rgb[2] /= count

    q4_rgb = list(map(int, q4_rgb))

    print(q4_rgb)

    count=0
    for x in range(int(q5[0][0]), int(q5[1][0])):
      for y in range(int(q5[0][1]), int(q5[1][1])):
        # (4)  Get the RGB color of the pixel
        [r, g, b] = img[x, y]

        q5_rgb[0] += r
        q5_rgb[1] += g
        q5_rgb[2] += b

        count += 1

    q5_rgb[0] /= count
    q5_rgb[1] /= count
    q5_rgb[2] /= count

    q5_rgb = list(map(int, q5_rgb))

    print(q5_rgb)

    f = open('analysis.csv', 'w+')
    f.write('{0},{1},{2},'.format(q1_rgb[0],q1_rgb[1],q1_rgb[2]))
    f.write('{0},{1},{2},'.format(q2_rgb[0],q2_rgb[1],q2_rgb[2]))
    f.write('{0},{1},{2},'.format(q3_rgb[0],q3_rgb[1],q3_rgb[2]))
    f.write('{0},{1},{2},'.format(q4_rgb[0],q4_rgb[1],q4_rgb[2]))
    f.write('{0},{1},{2}'.format(q5_rgb[0],q5_rgb[1],q5_rgb[2]))
    f.close()

def main():
    parser = argparse.ArgumentParser(description='Run the SuperCollider image analyzer')
    parser.add_argument('-p', '--path', dest='path', metavar='P', type=str, default="", help='the path to the input image')
    args = parser.parse_args()

    output_analysis(args.path)

if __name__ == '__main__':
    main()