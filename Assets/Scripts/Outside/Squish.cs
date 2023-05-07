using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Squish : MonoBehaviour
{
    public float ySquish = 0.6f;
    public float zStretch = 0.3f;
    private float zSpeed;
    public float ySpeed = 1.5f;
    private float t = 0.0f;
    public Transform target;
    // Start is called before the first frame update
    void Start()
    {
        zSpeed = ySpeed * (zStretch / ySquish);
        target = this.transform;
    }

    // Update is called once per frame
    void Update()
    {
        //t = Mathf.PingPong(speed * Time.time, 1);
        target.localScale = new Vector3(target.localScale.z - Mathf.PingPong(Time.time*zSpeed, (target.localScale.z*zStretch)), target.localScale.z + Mathf.PingPong(Time.time * ySpeed, (target.localScale.z * ySquish)), target.localScale.z);
    }
}
