using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeBehaviour : MonoBehaviour
{
    public Vector3 RotateAmount = new Vector3(1f,1f,1f);
    public float Speed = 10f;
    // Start is called before the first frame update
    void Start()
    {
        UnityMessageManager.Instance.OnMessage += Instance_OnMessage;
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(RotateAmount * Speed * Time.deltaTime);
        if(Time.time % 5 == 0)
        {
            UnityMessageManager.Instance.SendMessageToFlutter("Alive:" + Time.time);
        }
    }

    public void SetRotationSpeed(float speed)
    {
        Speed = speed;
    }

    private void Instance_OnMessage(string message)
    {
        UnityMessageManager.Instance.SendMessageToFlutter("Heard:" + message + ":" + Time.time);
    }
}
