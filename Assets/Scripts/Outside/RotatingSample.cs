using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotatingSample : MonoBehaviour
{

    public Vector3 RotateAmount = new Vector3(0, 1, 0);
    float min;
    float max;
    public float speed = 0.2f;

    // Start is called before the first frame update
    void Start()
    {
        min = transform.position.y;
        max = transform.position.y + 0.3f;
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(RotateAmount * Time.deltaTime);
        transform.position = new Vector3(transform.position.x, Mathf.PingPong(Time.time * speed, max - min) + min, transform.position.z);
    }
}
